"""Compose lifecycle, isolated workspaces, evidence and structured results."""
import fcntl
import hashlib
import http.client
import ipaddress
import json
import os
import platform
import signal
import shutil
import subprocess
import time
import uuid
from pathlib import Path
from urllib.parse import urlsplit
import xml.etree.ElementTree as ET

import yaml

from .manifest import inside, ManifestError


class CheckFailure(RuntimeError):
    pass


class Blocked(RuntimeError):
    pass


class Runner:
    def __init__(self, manifest, run_dir, mode="managed", project=None):
        self.manifest = manifest
        self.run_dir = Path(run_dir).resolve()
        # Never permit staging/cleanup to overwrite source inputs.
        if self.run_dir == manifest.root or manifest.root.is_relative_to(self.run_dir):
            raise ManifestError("run directory must not contain the repository")
        if self.run_dir.is_relative_to(manifest.setup):
            raise ManifestError("run directory must be outside the lab setup")
        self.run_dir.mkdir(parents=True, exist_ok=True)
        self.mode = mode
        self.results = []
        self.command_number = len(list((self.run_dir / "logs").glob("*.txt")))
        fingerprint = hashlib.sha256(json.dumps(manifest.data, sort_keys=True).encode()).hexdigest()
        state_path = self.run_dir / "state.json"
        if state_path.exists():
            self.state = json.loads(state_path.read_text())
            identity = (fingerprint, manifest.variant, mode, str(manifest.path))
            stored = tuple(self.state[k] for k in ("fingerprint", "variant", "mode", "manifest"))
            if identity != stored or (project and project != self.state["project"]):
                raise ManifestError("run directory belongs to another manifest, variant, mode or project")
            results_path = self.run_dir / "results.json"
            if results_path.exists():
                self.results = json.loads(results_path.read_text())["results"]
        else:
            if mode == "existing" and not project:
                raise ManifestError("existing mode requires --project (Compose project name)")
            if mode == "managed" and project:
                raise ManifestError("managed mode assigns its own isolated project name")
            self.state = {
                "fingerprint": fingerprint, "variant": manifest.variant, "mode": mode,
                "manifest": str(manifest.path),
                "project": project or "seedtest-" + uuid.uuid4().hex[:16],
                "up_attempted": False, "staged": False,
            }
            self.save_state()
        self.project = self.state["project"]
        self.workspace = self.run_dir / "workspace"
        self.setup = (self.workspace / manifest.config["setup"]) if mode == "managed" else manifest.setup
        self.compose = (self.run_dir / "compose.yaml") if mode == "managed" else inside(
            self.setup, manifest.data["runtime"]["compose"])
        (self.run_dir / "manifest.yaml").write_text(yaml.safe_dump(manifest.data, sort_keys=False))

    def save_state(self):
        (self.run_dir / "state.json").write_text(json.dumps(self.state, indent=2) + "\n")

    def command(self, argv, cwd=None, timeout=60):
        self.command_number += 1
        logs = self.run_dir / "logs"
        logs.mkdir(exist_ok=True)
        path = logs / f"{self.command_number:04d}.txt"
        started = time.monotonic()
        stdout_path = path.with_suffix(".stdout")
        stderr_path = path.with_suffix(".stderr")
        with path.open("w") as log, stdout_path.open("w") as stdout, stderr_path.open("w") as stderr:
            log.write(json.dumps({"argv": argv, "cwd": str(cwd or self.setup)}) + "\n")
            log.flush()
            try:
                process = subprocess.Popen(argv, cwd=cwd or self.setup, stdout=stdout,
                                           stderr=stderr, start_new_session=True)
            except OSError as exc:
                raise Blocked(f"cannot execute {argv[0]}: {exc}") from exc
            try:
                code = process.wait(timeout=timeout)
            except BaseException:
                # Also terminate descendants on timeout, Ctrl-C and CI cancellation.
                try:
                    os.killpg(process.pid, signal.SIGTERM)
                    process.wait(timeout=3)
                except subprocess.TimeoutExpired:
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
                except ProcessLookupError:
                    pass
                raise
            finally:
                stdout.flush()
                stderr.flush()
                log.write("STDOUT:\n" + stdout_path.read_text(errors="replace"))
                log.write("\nSTDERR:\n" + stderr_path.read_text(errors="replace"))
        text = stdout_path.read_text(errors="replace")
        return code, text, str(path.relative_to(self.run_dir)), time.monotonic() - started

    def docker(self, args, timeout=60):
        return self.command(["docker", *args], cwd=self.manifest.root, timeout=timeout)

    def dc(self, args, timeout=60):
        return self.docker(["compose", "--project-name", self.project, "-f", str(self.compose), *args], timeout)

    @staticmethod
    def successful(result):
        if result[0]:
            raise CheckFailure(f"command exited {result[0]}; see {result[2]}: {result[1][-1800:]}")
        return result[1]

    def lock(self):
        """Local serialization; subnet checks also protect separately started runs."""
        lock = open("/tmp/seedlab-testing-compose.lock", "a")
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            lock.close()
            raise Blocked("another local SEED lab test command is running")
        return lock

    def preflight(self):
        if platform.system() != "Linux":
            raise Blocked("this backend needs Linux with local Docker; run inside a Linux VM/WSL")
        info_format = '{"Architecture":{{json .Architecture}},"OperatingSystem":{{json .OperatingSystem}},"KernelVersion":{{json .KernelVersion}},"ServerVersion":{{json .ServerVersion}}}'
        result = self.docker(["info", "--format", info_format])
        if result[0]:
            raise Blocked(f"Docker daemon unavailable; see {result[2]}")
        info = json.loads(result[1])
        arch = {"x86_64": "amd64", "aarch64": "arm64"}.get(info["Architecture"], info["Architecture"])
        if arch != self.manifest.config["architecture"]:
            raise Blocked(f"requires native {self.manifest.config['architecture']}; daemon is {arch}")
        context = json.loads(self.successful(self.docker(["context", "inspect"])))
        endpoint = os.environ.get("DOCKER_HOST") or context[0]["Endpoints"]["docker"]["Host"]
        if not endpoint.startswith("unix://"):
            raise Blocked("remote Docker is unsupported: HTTP probes must reach the local lab network")
        self.successful(self.docker(["compose", "version"]))
        environment = {
            "host_os": platform.platform(), "host_kernel": platform.release(),
            "docker_os": info["OperatingSystem"], "docker_kernel": info["KernelVersion"],
            "docker_architecture": arch, "docker_version": info["ServerVersion"],
        }
        (self.run_dir / "environment.json").write_text(json.dumps(environment, indent=2) + "\n")
        original = inside(self.manifest.setup, self.manifest.data["runtime"]["compose"])
        if self.mode == "managed" and original.is_file():
            cfg = json.loads(self.successful(self.docker([
                "compose", "-f", str(original), "config", "--format", "json"])))
            self.check_subnets(cfg)
        return "local Docker and native architecture available"

    def prepare(self):
        if self.mode != "managed":
            raise ManifestError("prepare is unavailable in existing mode")
        if self.state["staged"]:
            raise ManifestError("workspace already prepared; use a new run directory for a fresh run")
        paths = [self.manifest.config["setup"], *self.manifest.data.get("dependencies", [])]
        for rel in sorted(set(paths), key=lambda s: len(Path(s).parts)):
            source = inside(self.manifest.root, rel)
            if self.run_dir.is_relative_to(source):
                raise ManifestError(f"staging source contains the run directory: {source}")
            target = inside(self.workspace, rel)
            if target.exists():
                continue
            target.parent.mkdir(parents=True, exist_ok=True)
            if source.is_dir():
                shutil.copytree(source, target, symlinks=False)
            else:
                shutil.copy2(source, target)
        for step in self.manifest.data.get("prepare", []):
            cwd = inside(self.setup, step.get("cwd", "."))
            self.successful(self.command(step["argv"], cwd, step.get("timeout", 300)))
            for output in step["expected"]:
                if not inside(self.setup, output).exists():
                    raise CheckFailure(f"prepare {step['id']}: missing output {output}")
        original = inside(self.setup, self.manifest.data["runtime"]["compose"])
        cfg = json.loads(self.successful(self.docker([
            "compose", "--project-name", self.project, "-f", str(original), "config", "--format", "json"])))
        declared = self.manifest.data["runtime"]["services"]
        if set(cfg["services"]) != set(declared):
            raise ManifestError("every Compose service must have a declared role")
        images = {spec["image"]: f"{self.project}-{index}:test"
                  for index, spec in enumerate(cfg["services"].values()) if "build" in spec and "image" in spec}
        for name, spec in cfg["services"].items():
            spec["container_name"] = f"{self.project}-{name}"
            if "image" in spec:
                spec["image"] = images.get(spec["image"], spec["image"])
            build = spec.get("build")
            if build:
                context = Path(build["context"]).resolve()
                if not context.is_relative_to(self.workspace):
                    raise ManifestError(f"unstaged build context {context}; declare dependencies")
                if not (context / build.get("dockerfile", "Dockerfile")).is_file():
                    raise ManifestError(f"Dockerfile missing in {context}")
            for mount in spec.get("volumes", []):
                if mount["type"] == "bind" and not Path(mount["source"]).resolve().is_relative_to(self.workspace):
                    raise ManifestError("managed bind mounts must stay within the staged workspace")
        for kind in ("networks", "volumes"):
            for name, spec in cfg.get(kind, {}).items():
                if spec.get("external"):
                    raise ManifestError(f"external {kind} unsupported in managed mode")
                spec["name"] = f"{self.project}-{name}"
        cfg["name"] = self.project
        self.compose.write_text(yaml.safe_dump(cfg, sort_keys=False))
        self.state["staged"] = True
        self.save_state()
        return "setup staged; names isolated; lab addresses and service configuration preserved"

    def require_prepared(self):
        if not self.state["staged"]:
            raise ManifestError("run prepare first with this --run-dir")

    def build(self):
        self.require_prepared()
        self.successful(self.dc(["build"], self.manifest.data.get("build", {}).get("timeout", 1200)))
        return "images built"

    def check_subnets(self, cfg=None):
        cfg = cfg if cfg is not None else yaml.safe_load(self.compose.read_text())
        wanted = [ipaddress.ip_network(item["subnet"]) for net in cfg.get("networks", {}).values()
                  for item in net.get("ipam", {}).get("config", []) if "subnet" in item]
        names = self.successful(self.docker(["network", "ls", "--format", "{{.ID}}"])).split()
        if names:
            networks = json.loads(self.successful(self.docker(["network", "inspect", *names])))
            for net in networks:
                owner = (net.get("Labels") or {}).get("com.docker.compose.project")
                if owner == self.project:
                    continue
                for item in net.get("IPAM", {}).get("Config") or []:
                    if not item.get("Subnet"):
                        continue
                    occupied = ipaddress.ip_network(item["Subnet"])
                    if any(p.version == occupied.version and p.overlaps(occupied) for p in wanted):
                        raise Blocked(f"lab subnet overlaps existing Docker network {net['Name']} ({occupied}); nothing removed")

    def up(self):
        self.require_prepared()
        self.check_subnets()
        self.state["up_attempted"] = True
        self.save_state()
        services = [name for name, spec in self.manifest.data["runtime"]["services"].items()
                    if spec["role"] != "build-only"]
        self.successful(self.dc(["up", "-d", "--no-build", *services], 180))
        return "services started (run readiness next)"

    def inspect_service(self, service):
        ids = self.successful(self.dc(["ps", "-a", "-q", service])).split()
        if len(ids) != 1:
            raise CheckFailure(f"expected exactly one {service} container; found {len(ids)}")
        return json.loads(self.successful(self.docker(["inspect", ids[0]])))[0]

    def probe(self, check):
        kind = check["type"]
        timeout = check.get("timeout", 10)
        if kind == "exec":
            result = self.dc(["exec", "-T", check["service"], *check["argv"]], timeout)
            expected = check.get("expect_exit", 0)
            if result[0] != expected:
                raise CheckFailure(f"exit {result[0]}, expected {expected}; see {result[2]}")
            if check.get("stdout_contains", "") not in result[1]:
                raise CheckFailure(f"expected output missing; see {result[2]}")
            return {"exit": result[0], "log": result[2]}
        if kind in ("service-state", "container-ip"):
            info = self.inspect_service(check["service"])
            if kind == "service-state":
                state = info["State"]
                actual = "exited-0" if state["Status"] == "exited" and state["ExitCode"] == 0 else state["Status"]
            else:
                actual = [net["IPAddress"] for net in info["NetworkSettings"]["Networks"].values()]
            passed = check["expected"] in actual if isinstance(actual, list) else actual == check["expected"]
            if not passed:
                raise CheckFailure(f"observed {actual}, expected {check['expected']}")
            return {"actual": actual, "expected": check["expected"]}
        if kind == "file":
            source = inside(self.setup, check["source"])
            expected = hashlib.sha256(source.read_bytes()).hexdigest()
            text = self.successful(self.dc(["exec", "-T", check["service"], "sha256sum", "--", check["path"]], timeout))
            actual = text.split()[0]
            if actual != expected:
                raise CheckFailure(f"deployed file differs from {check['source']}: {actual} != {expected}")
            if check.get("executable"):
                self.successful(self.dc(["exec", "-T", check["service"], "test", "-x", check["path"]], timeout))
            return {"actual_sha256": actual, "source_sha256": expected}
        if kind == "http":
            url = urlsplit(check["url"])
            if url.scheme != "http" or not url.hostname or url.username or url.password:
                raise ManifestError("HTTP probe requires an http URL without credentials")
            address = check.get("connect_address", url.hostname)
            connection = http.client.HTTPConnection(address, url.port or 80, timeout=timeout)
            headers = {"Host": url.netloc, **check.get("headers", {})}
            try:
                connection.request("GET", url.path + ("?" + url.query if url.query else ""), headers=headers)
                response = connection.getresponse()
                body = response.read(1024 * 1024).decode("utf-8", errors="replace")
                actual = {"status": response.status, "headers": dict(response.getheaders()), "body": body}
                # Capture each attempt, including failed CGI responses, without relying on proxies.
                evidence = self.run_dir / f"http-{check['id']}.json"
                evidence.write_text(json.dumps(actual, indent=2) + "\n")
                if response.status != check["expect_status"]:
                    raise CheckFailure(f"HTTP {response.status}, expected {check['expect_status']}; see {evidence.name}")
                if check.get("body_contains", "") not in body:
                    raise CheckFailure(f"expected response text missing; see {evidence.name}")
                for name, value in check.get("expected_headers", {}).items():
                    if value.lower() not in (response.getheader(name) or "").lower():
                        raise CheckFailure(f"header {name} does not contain {value}")
                return {"http_status": response.status, "url": check["url"], "connect_address": address,
                        "evidence": evidence.name}
            finally:
                connection.close()
        raise ManifestError(f"unsupported probe {kind}")

    def checks(self, stage):
        checks = self.manifest.data["runtime"]["readiness"] if stage == "readiness" else self.manifest.data["checks"]
        required_failed = False
        for check in checks:
            started = time.monotonic()
            status, detail = "FAIL", {}
            for attempt in range(1, check.get("retries", 1) + 1):
                try:
                    detail = self.probe(check)
                    status = "PASS"
                    break
                except (CheckFailure, OSError, http.client.HTTPException, subprocess.TimeoutExpired) as exc:
                    detail = {"message": str(exc)}
                    if attempt < check.get("retries", 1):
                        time.sleep(check.get("interval", 1))
            required = check.get("required", True)
            required_failed |= status != "PASS" and required
            self.record(stage, check["id"], status, started, required=required,
                        requirement=self.manifest.data["requirements"][check["requirement"]],
                        attempts=attempt, **detail)
        if required_failed:
            raise CheckFailure(f"{stage}: required environment checks failed")
        return f"{len(checks)} checks executed"

    def collect(self):
        if not self.compose.exists():
            return "no Compose environment to collect"
        for name, args in (("compose-ps", ["ps", "-a", "--format", "json"]),
                           ("compose-logs", ["logs", "--no-color", "--tail", "200"])):
            result = self.dc(args, 30)
            (self.run_dir / f"{name}.txt").write_text(result[1])
        ids = self.successful(self.dc(["ps", "-a", "-q"])).split()
        if ids:
            inspected = json.loads(self.successful(self.docker(["inspect", *ids])))
            # Keep diagnostic facts, not full container environment variables.
            evidence = [{"id": i["Id"], "image_id": i["Image"], "state": i["State"],
                         "networks": i["NetworkSettings"]["Networks"]} for i in inspected]
            (self.run_dir / "containers.json").write_text(json.dumps(evidence, indent=2) + "\n")
        return "service state, logs and image IDs collected"

    def down(self):
        if self.mode != "managed":
            raise ManifestError("existing mode never stops or removes user resources")
        if not self.state["up_attempted"]:
            return "this run has not attempted startup; nothing removed"
        self.successful(self.dc(["down", "--volumes", "--timeout", "10"], 90))
        self.state["up_attempted"] = False
        self.save_state()
        return "only this run's Compose resources removed; images and evidence retained"

    def record(self, stage, name, status, started, **detail):
        self.results.append({"stage": stage, "id": name, "status": status,
                             "duration": round(time.monotonic() - started, 3), **detail})
        print(f"{status:7} {stage}/{name}: {detail.get('message', '')}", flush=True)
        self.report()

    def report(self):
        failed = [r for r in self.results if r["status"] != "PASS" and r.get("required", True)]
        status = next((s for s in ("ERROR", "BLOCKED", "FAIL")
                       if any(r["status"] == s for r in failed)), "PASS")
        if status == "PASS" and self.state.get("execution") == "RUNNING":
            status = "RUNNING"
        summary = {"lab": self.manifest.data["id"], "variant": self.manifest.variant,
                   "mode": self.mode, "project": self.project, "status": status,
                   "command": self.state.get("command"), "results": self.results}
        completed_checks = {r["id"] for r in self.results if r["stage"] in ("readiness", "check")}
        summary["not_run"] = [c["id"] for c in self.manifest.data["runtime"]["readiness"] + self.manifest.data["checks"]
                              if c["id"] not in completed_checks]
        (self.run_dir / "results.json").write_text(json.dumps(summary, indent=2) + "\n")
        suite = ET.Element("testsuite", name=summary["lab"], tests=str(len(self.results)),
                           failures=str(sum(r["status"] == "FAIL" for r in self.results)),
                           errors=str(sum(r["status"] in ("ERROR", "BLOCKED") for r in self.results)))
        for result in self.results:
            case = ET.SubElement(suite, "testcase", name=f"{result['stage']}/{result['id']}",
                                 time=str(result["duration"]))
            if result["status"] != "PASS":
                tag = "error" if result["status"] in ("ERROR", "BLOCKED") else "failure"
                ET.SubElement(case, tag, message=result.get("message", result["status"]))
        ET.ElementTree(suite).write(self.run_dir / "junit.xml", encoding="utf-8", xml_declaration=True)
        lines = [f"# {summary['lab']} / {summary['variant']}", "", f"Mode: {self.mode}; result: **{status}**", "",
                 "| Stage | Check | Result |", "| --- | --- | --- |"]
        lines += [f"| {r['stage']} | {r['id']} | {r['status']} |" for r in self.results]
        if summary["not_run"]:
            lines += ["", "Checks not executed: " + ", ".join(summary["not_run"])]
        lines += ["", "Environment acceptance only; exploitability and unregistered labs are not verified.", ""]
        (self.run_dir / "summary.md").write_text("\n".join(lines))

    def stage(self, name):
        started = time.monotonic()
        try:
            if name == "validate":
                detail = self.manifest.static()
            elif name in ("readiness", "check"):
                detail = self.checks(name)
            else:
                detail = getattr(self, name)()
            self.record(name, name, "PASS", started, message=detail)
            return 0
        except (KeyboardInterrupt, Exception) as exc:
            if isinstance(exc, Blocked):
                status, code = "BLOCKED", 2
            elif isinstance(exc, CheckFailure):
                status, code = "FAIL", 1
            elif isinstance(exc, KeyboardInterrupt):
                status, code = "ERROR", 130
            else:
                status, code = "ERROR", 2
            self.record(name, name, status, started, message=str(exc) or "interrupted")
            return code

    def run(self, command):
        if self.mode == "existing" and command in ("prepare", "build", "up", "down"):
            raise ManifestError(f"{command} is forbidden in existing mode")
        lock = self.lock()
        self.state.update(command=command, execution="RUNNING")
        self.save_state()
        try:
            if command != "all":
                return self.stage(command)
            stages = ["validate", "preflight"]
            if self.mode == "managed":
                stages += ["prepare", "build", "up"]
            stages += ["readiness", "check"]
            code = 0
            try:
                for stage in stages:
                    code = self.stage(stage)
                    if code:
                        break
            finally:
                # Collection failure must never prevent teardown or hide the initial failure.
                try:
                    has_environment = self.state["up_attempted"] or (
                        self.mode == "existing" and any(r["stage"] == "preflight" and r["status"] == "PASS" for r in self.results))
                    collect_code = self.stage("collect") if has_environment else 0
                finally:
                    down_code = self.stage("down") if self.mode == "managed" else 0
                code = code or collect_code or down_code
            return code
        finally:
            self.state["execution"] = "FINISHED"
            self.save_state()
            self.report()
            lock.close()
