"""Compose lifecycle, isolated workspaces, evidence and structured results."""
import fcntl
import hashlib
import http.client
import ipaddress
import json
import importlib.util
import os
import platform
import re
import socket
import stat
import signal
import shutil
import subprocess
import sys
import time
import tarfile
import uuid
from pathlib import Path
from urllib.parse import urlsplit
import xml.etree.ElementTree as ET

import yaml

from .manifest import inside, ManifestError
from .errors import CheckFailure, Blocked
from .software import software_probe
from .web import login_probe


class Runner:
    def __init__(self, manifest, run_dir, mode="managed", project=None, tun_device=None):
        self.manifest = manifest
        self.backend = manifest.data["runtime"]["backend"]
        if self.backend == "host" and mode == "existing":
            raise ManifestError("host tests use an isolated workspace; existing mode is for Compose")
        self.run_dir = Path(run_dir).resolve()
        # Never permit staging/cleanup to overwrite source inputs.
        if self.run_dir == manifest.root or manifest.root.is_relative_to(self.run_dir):
            raise ManifestError("run directory must not contain the repository")
        if self.run_dir.is_relative_to(manifest.setup):
            raise ManifestError("run directory must be outside the lab setup")
        self.run_dir.mkdir(parents=True, exist_ok=True)
        self.mode = mode
        self.tun_device = Path(tun_device).resolve() if tun_device else None
        if self.tun_device:
            device = self.tun_device.stat()
            if not stat.S_ISCHR(device.st_mode) or (os.major(device.st_rdev), os.minor(device.st_rdev)) != (10, 200):
                raise ManifestError("--tun-device must identify a real TUN character device (10:200)")
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
                "manifest": str(manifest.path), "backend": self.backend,
                "project": project or "seedtest-" + uuid.uuid4().hex[:16],
                "up_attempted": False, "staged": False,
            }
            self.save_state()
        self.project = self.state["project"]
        recorded_device = self.state.get("tun_device")
        if recorded_device and self.tun_device and recorded_device != str(self.tun_device):
            raise ManifestError("run directory belongs to another TUN device mapping")
        if recorded_device and not self.tun_device:
            self.tun_device = Path(recorded_device)
        self.state["tun_device"] = str(self.tun_device) if self.tun_device else None
        self.save_state()
        self.workspace = self.run_dir / "workspace"
        self.setup = (self.workspace / manifest.config["setup"]) if mode == "managed" else manifest.setup
        self.compose = (self.run_dir / "compose.yaml") if mode == "managed" else inside(
            self.setup, manifest.data["runtime"].get("compose", ".unused-host"))
        (self.run_dir / "manifest.yaml").write_text(yaml.safe_dump(manifest.data, sort_keys=False))

    def save_state(self):
        (self.run_dir / "state.json").write_text(json.dumps(self.state, indent=2) + "\n")

    def command(self, argv, cwd=None, timeout=60, env=None):
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
                                           stderr=stderr, start_new_session=True,
                                           env=None if env is None else {**os.environ, **env})
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

    def build_command(self, args, timeout):
        """Retry only recognized registry transport failures, within one deadline."""
        deadline = time.monotonic() + timeout
        for attempt in range(3):
            result = self.docker(args, max(1, deadline - time.monotonic()))
            if result[0] == 0:
                return result
            log = (self.run_dir / result[2]).read_text(errors="replace")
            transient = any(message in log for message in ("EOF", "TLS handshake timeout", "connection reset by peer", "i/o timeout"))
            registry = any(message in log for message in ("docker.io", "registry", "load metadata", "fetch anonymous token"))
            if not (transient and registry) or attempt == 2 or time.monotonic() + 3 >= deadline:
                return result
            print(f"Registry transport failed; retrying build ({attempt + 2}/3). See {result[2]}", flush=True)
            time.sleep(2)

    def lock(self):
        """Local serialization; subnet checks also protect separately started runs."""
        lock = open("/tmp/seedlab-testing-compose.lock", "a")
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            lock.close()
            raise Blocked("another local SEED lab test command is running")
        return lock

    def expand_host(self, value):
        return (value.replace("{setup}", str(self.setup)).replace("{uid}", str(os.getuid()))
                .replace("{python}", sys.executable)
                .replace("{tun_device}", str(self.tun_device or "/dev/net/tun")))

    def host_command(self, argv, cwd=None, timeout=60, env=None, privileged=False):
        argv = [self.expand_host(arg) for arg in argv]
        if argv and argv[0] in ("python", "python3"):
            argv[0] = sys.executable
        if privileged and os.geteuid() != 0:
            argv = ["sudo", "-n", *argv]
        return self.command(argv, cwd or self.setup, timeout, env)

    def host_preflight(self):
        profile = self.manifest.data.get("host", {})
        arch = {"x86_64": "amd64", "aarch64": "arm64"}.get(platform.machine(), platform.machine())
        facts = {"host_os": platform.platform(), "host_kernel": platform.release(), "host_libc": platform.libc_ver(),
                 "host_architecture": arch, "host_uid": os.getuid(),
                 "host_commands": {name: shutil.which(name) for name in profile.get("commands", []) + profile.get("architecture_commands", {}).get(arch, [])}}
        (self.run_dir / "environment.json").write_text(json.dumps(facts, indent=2) + "\n")
        if arch != self.manifest.config["architecture"]:
            raise Blocked(f"requires native {self.manifest.config['architecture']}; host is {arch}")
        if profile.get("non_root") and os.geteuid() == 0:
            raise Blocked("run this case as an ordinary user with noninteractive sudo")
        missing = [name for name, path in facts["host_commands"].items() if path is None]
        if missing:
            packages = profile.get("packages", []) + profile.get("architecture_packages", {}).get(arch, [])
            raise Blocked(f"missing host commands {missing}; install prerequisites before testing: {packages}")
        if profile.get("sudo") and os.geteuid() != 0:
            result = self.command(["sudo", "-n", "true"], self.manifest.root)
            if result[0]:
                raise Blocked(f"this case requires noninteractive host sudo; see {result[2]}")
        return facts

    def preflight(self):
        if "emulator" in self.manifest.data:
            self.emulator_source()
            missing = [name for name in ("geopy", "requests", "networkx", "scapy") if importlib.util.find_spec(name) is None]
            if missing:
                raise Blocked(f"install dependencies from lab-setup/testing/requirements.txt; missing {missing}")
        if platform.system() != "Linux":
            raise Blocked("tests require a native Linux host")
        facts = self.host_preflight() if self.backend == "host" or "host" in self.manifest.data else {}
        if self.backend == "host":
            return "native host and declared commands available"
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
            **facts, "host_os": platform.platform(), "host_kernel": platform.release(),
            "docker_os": info["OperatingSystem"], "docker_kernel": info["KernelVersion"],
            "docker_architecture": arch, "docker_version": info["ServerVersion"],
            "explicit_tun_device": str(self.tun_device) if self.tun_device else None,
        }
        (self.run_dir / "environment.json").write_text(json.dumps(environment, indent=2) + "\n")
        original = inside(self.manifest.setup, self.manifest.data["runtime"]["compose"])
        cfg = None
        if self.mode == "managed" and original.is_file():
            cfg = json.loads(self.successful(self.docker([
                "compose", "-f", str(original), "config", "--format", "json"])))
            self.check_subnets(cfg)
        if cfg:
            for service, spec in cfg.get("services", {}).items():
                for device in spec.get("devices", []):
                    source = device.get("source") if isinstance(device, dict) else str(device).split(":")[0]
                    if source == "/dev/net/tun" and self.tun_device:
                        source = str(self.tun_device)
                    if not source or not Path(source).exists():
                        raise Blocked(f"{service} requires host device {source}; it is not created or substituted automatically")
        return "local Docker and native architecture available"

    def prepare(self):
        if self.mode != "managed":
            raise ManifestError("prepare is unavailable in existing mode")
        if self.state["staged"]:
            raise ManifestError("workspace already prepared; use a new run directory for a fresh run")
        # Standalone `prepare` needs the same input guarantees as the full lifecycle.
        self.manifest.static()
        self.workspace.mkdir(parents=True, exist_ok=True, mode=0o700)
        self.workspace.chmod(0o700)
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
        for tool in self.manifest.data.get("tools", []):
            destination = inside(self.setup, tool["destination"])
            if destination.exists():
                raise ManifestError(f"tool would replace a staged lab file: {destination}")
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(inside(self.manifest.root, tool["source"]), destination)
        prepare_env = None
        if "emulator" in self.manifest.data:
            source = self.emulator_source()
            revision = self.manifest.data["emulator"]["revision"]
            archive = self.run_dir / "emulator-sdk.tar"
            sdk = self.run_dir / "emulator-sdk"
            sdk.mkdir(exist_ok=True)
            self.successful(self.command(["git", "-C", str(source), "archive", "--format=tar", "--output", str(archive), revision, "seedemu"], cwd=self.manifest.root))
            with tarfile.open(archive) as bundle:
                for member in bundle.getmembers():
                    if member.issym() or member.islnk() or not (sdk / member.name).resolve().is_relative_to(sdk):
                        raise ManifestError(f"unsupported emulator archive entry: {member.name}")
                bundle.extractall(sdk)
            prepare_env = {"PYTHONPATH": str(sdk)}
            (self.run_dir / "emulator.json").write_text(json.dumps({"revision": revision, "source": str(source),
                "archive_sha256": hashlib.sha256(archive.read_bytes()).hexdigest(), "working_tree_changes_ignored": True}, indent=2) + "\n")
        for step in self.manifest.preparation():
            cwd = inside(self.setup, step.get("cwd", "."))
            result = self.host_command(step["argv"], cwd, step.get("timeout", 300),
                                       prepare_env, step.get("privileged", False))
            if result[0]:
                stderr = (self.run_dir / result[2]).with_suffix(".stderr")
                error = stderr.read_text(errors="replace")[-1800:] if stderr.is_file() else ""
                raise CheckFailure(f"host prepare {step['id']} exited {result[0]}; see {result[2]}: {result[1][-1800:]}{error}")
            for output in step["expected"]:
                if not inside(self.setup, output).exists():
                    raise CheckFailure(f"prepare {step['id']}: missing output {output}")
        if self.backend == "host":
            self.state["staged"] = True
            self.save_state()
            return "sources staged and compiled on the host"
        original = inside(self.setup, self.manifest.data["runtime"]["compose"])
        cfg = json.loads(self.successful(self.docker([
            "compose", "--project-name", self.project, "-f", str(original), "config", "--format", "json"])))
        declared = self.manifest.data["runtime"]["services"]
        if set(cfg["services"]) != set(declared):
            raise ManifestError("every Compose service must have a declared role")
        images = {spec["image"]: f"{self.project}-{index}:test"
                  for index, spec in enumerate(cfg["services"].values()) if "build" in spec and "image" in spec}
        producers = {spec["image"]: name for name, spec in cfg["services"].items() if "build" in spec and "image" in spec}
        dependencies = {}
        dockerfile_sources = {}
        for name, spec in cfg["services"].items():
            spec["container_name"] = f"{self.project}-{name}"
            if "image" in spec:
                spec["image"] = images.get(spec["image"], spec["image"])
            if self.tun_device:
                for device in spec.get("devices", []):
                    if device.get("source") == "/dev/net/tun":
                        device["source"] = str(self.tun_device)
            build = spec.get("build")
            if build:
                context = Path(build["context"]).resolve()
                if not context.is_relative_to(self.workspace):
                    raise ManifestError(f"unstaged build context {context}; declare dependencies")
                if not (context / build.get("dockerfile", "Dockerfile")).is_file():
                    raise ManifestError(f"Dockerfile missing in {context}")
                dockerfile = context / build.get("dockerfile", "Dockerfile")
                text = dockerfile_sources.setdefault(dockerfile, dockerfile.read_text())
                parents = re.findall(r"(?im)^FROM\s+(\S+)", text)
                dependencies[name] = {producers[p] for p in parents if p in producers}
                rewritten = re.sub(r"(?im)^(FROM\s+)(\S+)", lambda m: m[1] + images.get(m[2], m[2]), text)
                if text != rewritten:
                    dockerfile.write_text(rewritten)
            for mount in spec.get("volumes", []):
                if mount["type"] == "bind" and not Path(mount["source"]).resolve().is_relative_to(self.workspace):
                    allowed = {Path(p).resolve() for p in self.manifest.data["runtime"].get("allowed_host_binds", [])}
                    if Path(mount["source"]).resolve() not in allowed:
                        raise ManifestError("managed host bind mounts must be explicitly declared")
        for kind in ("networks", "volumes"):
            for name, spec in cfg.get(kind, {}).items():
                if spec.get("external"):
                    raise ManifestError(f"external {kind} unsupported in managed mode")
                spec["name"] = f"{self.project}-{name}"
        cfg["name"] = self.project
        self.compose.write_text(yaml.safe_dump(cfg, sort_keys=False))
        order, groups = [], []
        pending = dict(dependencies)
        while pending:
            ready = sorted(name for name, parents in pending.items() if parents.issubset(order))
            if not ready:
                raise ManifestError(f"cyclic local image dependencies: {pending}")
            size = self.manifest.data.get("build", {}).get("batch_size", 1)
            groups.extend(ready[index:index + size] for index in range(0, len(ready), size))
            for name in ready:
                order.append(name)
                del pending[name]
        self.state["build_order"] = order
        self.state["build_groups"] = groups
        self.state["staged"] = True
        self.save_state()
        return "setup staged; names isolated; lab addresses and service configuration preserved"

    def require_prepared(self):
        if not self.state["staged"]:
            raise ManifestError("run prepare first with this --run-dir")

    def emulator_source(self):
        profile = self.manifest.data["emulator"]
        source = Path(os.environ.get(profile.get("source_env", "SEED_EMULATOR_SOURCE"), self.manifest.root.parent / "seed-emulator")).resolve()
        if not (source / ".git").exists():
            raise Blocked(f"provide the SEED Emulator checkout via {profile.get('source_env', 'SEED_EMULATOR_SOURCE')}")
        result = self.command(["git", "-C", str(source), "cat-file", "-e", profile["revision"] + ":seedemu"], cwd=self.manifest.root)
        if result[0]:
            raise Blocked(f"Emulator checkout lacks required revision {profile['revision']}")
        return source

    def build(self):
        self.require_prepared()
        if self.backend == "host":
            return "host compilation completed during prepare"
        groups = self.state.get("build_groups", [[service] for service in self.state.get("build_order", [])])
        for services in groups:
            self.successful(self.build_command([
                "compose", "--project-name", self.project, "-f", str(self.compose), "build", *services
            ], self.manifest.data.get("build", {}).get("timeout", 1200)))
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
        if self.backend == "host":
            return "host workspace ready; no containers started"
        self.check_subnets()
        self.state["up_attempted"] = True
        self.save_state()
        services = [name for name, spec in self.manifest.data["runtime"]["services"].items()
                    if spec["role"] != "build-only"]
        self.successful(self.dc(["up", "-d", "--no-build", *services],
                                self.manifest.data["runtime"].get("start_timeout", 180)))
        return "services started (run readiness next)"

    def inspect_service(self, service):
        ids = self.successful(self.dc(["ps", "-a", "-q", service])).split()
        if len(ids) != 1:
            raise CheckFailure(f"expected exactly one {service} container; found {len(ids)}")
        return json.loads(self.successful(self.docker(["inspect", ids[0]])))[0]

    def probe(self, check):
        kind = check["type"]
        timeout = check.get("timeout", 10)
        if kind in ("elf", "process-uid", "format-input", "buffer-input"):
            return software_probe(self, check)
        if kind == "web-login":
            return login_probe(self, check)
        if kind in ("exec", "host-exec"):
            result = (self.host_command(check["argv"], timeout=timeout, privileged=check.get("privileged", False))
                      if kind == "host-exec" else self.dc(["exec", "-T", check["service"], *check["argv"]], timeout))
            expected = check.get("expect_exit", 0)
            if result[0] != expected:
                raise CheckFailure(f"exit {result[0]}, expected {expected}; see {result[2]}")
            contains = self.expand_host(check.get("stdout_contains", "")) if kind == "host-exec" else check.get("stdout_contains", "")
            equals = self.expand_host(check.get("stdout_equals", "")) if kind == "host-exec" else check.get("stdout_equals", "")
            if contains not in result[1]:
                raise CheckFailure(f"expected output missing; see {result[2]}")
            if "stdout_equals" in check and result[1].strip() != equals:
                raise CheckFailure(f"output {result[1].strip()!r}, expected {check['stdout_equals']!r}; see {result[2]}")
            return {"exit": result[0], "log": result[2]}
        if kind == "tcp":
            with socket.create_connection((check["host"], check["port"]), timeout=timeout):
                return {"host": check["host"], "port": check["port"], "connected": True}
        if kind == "container-network-mode":
            actual = self.inspect_service(check["service"])["HostConfig"]["NetworkMode"]
            if actual != check["expected"]:
                raise CheckFailure(f"network mode {actual}, expected {check['expected']}")
            return {"actual": actual, "expected": check["expected"]}
        if kind == "service-group":
            ids = self.successful(self.dc(["ps", "-a", "-q"], timeout)).split()
            entries = json.loads(self.successful(self.docker(["inspect", *ids], timeout))) if ids else []
            states = {
                e["Config"]["Labels"]["com.docker.compose.service"]:
                ("exited-0" if e["State"]["Status"] == "exited" and e["State"].get("ExitCode") == 0
                 else e["State"]["Status"])
                for e in entries
            }
            invalid = {s: states.get(s, "missing") for s in check["services"] if states.get(s) != check["expected"]}
            if invalid:
                raise CheckFailure(f"services not {check['expected']}: {invalid}")
            return {"service_states": {s: states[s] for s in check["services"]}}
        if kind == "interface-addresses":
            actual, missing = {}, {}
            for service, expected in check["addresses"].items():
                text = self.successful(self.dc(["exec", "-T", service, "ip", "-j", "address", "show"], timeout))
                addresses = [i["local"] for net in json.loads(text) for i in net.get("addr_info", [])]
                actual[service] = addresses
                absent = set(expected) - set(addresses)
                if absent:
                    missing[service] = sorted(absent)
            if missing:
                raise CheckFailure(f"missing required interface addresses: {missing}")
            return {"interface_addresses": actual}
        if kind == "interface-ip":
            text = self.successful(self.dc(["exec", "-T", check["service"], "ip", "-j", "address", "show"], timeout))
            addresses = [item["local"] for interface in json.loads(text) for item in interface.get("addr_info", [])]
            if check["expected"] not in addresses:
                raise CheckFailure(f"interface addresses {addresses}, expected {check['expected']}")
            return {"actual": addresses, "expected": check["expected"]}
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
                for name in check.get("absent_headers", []):
                    if response.getheader(name) is not None:
                        raise CheckFailure(f"header {name} must be absent in the initial environment")
                return {"http_status": response.status, "url": check["url"], "connect_address": address,
                        "evidence": evidence.name}
            finally:
                connection.close()
        raise ManifestError(f"unsupported probe {kind}")

    def checks(self, stage):
        checks = self.manifest.checks(stage)
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
        files = []
        for step in self.manifest.preparation():
            for output in step["expected"]:
                path = inside(self.setup, output)
                if path.is_file():
                    info = path.stat()
                    files.append({"path": output, "uid": info.st_uid, "mode": oct(stat.S_IMODE(info.st_mode)),
                                  "sha256": hashlib.sha256(path.read_bytes()).hexdigest()})
        (self.run_dir / "host-files.json").write_text(json.dumps(files, indent=2) + "\n")
        if self.backend == "host":
            return "host build artifacts and command evidence collected"
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

    def strip_host_privileges(self):
        # Restrict cleanup to explicitly declared outputs in this run's workspace.
        if self.mode != "managed":
            return
        for step in self.manifest.preparation():
            for output in step["expected"]:
                path = inside(self.setup, output)
                if path.is_file() and path.stat().st_mode & (stat.S_ISUID | stat.S_ISGID):
                    privileged = path.stat().st_uid != os.geteuid()
                    self.successful(self.host_command(["chmod", "a-s", "--", str(path)],
                                                     cwd=self.manifest.root, privileged=privileged))

    def down(self):
        if self.mode != "managed":
            raise ManifestError("existing mode never stops or removes user resources")
        self.strip_host_privileges()
        if self.backend == "host":
            return "host build artifacts retained with Set-UID/Set-GID bits removed"
        if not self.state["up_attempted"]:
            return "this run has not attempted startup; nothing removed"
        self.successful(self.dc(["down", "--volumes", "--timeout", "10"],
                                self.manifest.data["runtime"].get("stop_timeout", 90)))
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
                   "mode": self.mode, "backend": self.backend, "project": self.project, "status": status,
                   "command": self.state.get("command"), "results": self.results}
        completed_checks = {r["id"] for r in self.results if r["stage"] in ("readiness", "check")}
        summary["not_run"] = [c["id"] for c in self.manifest.checks("readiness") + self.manifest.checks("check")
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
        lines += ["", "Environment acceptance for the selected manifest and architecture only.", ""]
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
                    has_environment = self.state["up_attempted"] or (self.backend == "host" and self.state["staged"]) or (
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
