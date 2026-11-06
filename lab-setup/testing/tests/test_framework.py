import copy
import hashlib
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
from pathlib import Path
import subprocess
import threading

import pytest
import yaml

from seedlab_testing.manifest import Manifest, ManifestError, TESTING
from seedlab_testing.runner import Runner, Blocked, CheckFailure


@pytest.fixture
def fixture_lab(tmp_path):
    root = tmp_path / "repo"
    setup = root / "lab/Labsetup"
    setup.mkdir(parents=True)
    (root / "manual.tex").write_text("Environment Setup")
    (setup / "Dockerfile").write_text("FROM scratch\n")
    (setup / "identity").write_text("expected deployed file")
    compose = {
        "services": {"victim": {"build": ".", "image": "shared-image", "container_name": "fixed-name",
                                 "networks": {"lan": {"ipv4_address": "10.9.0.5"}}}},
        "networks": {"lan": {"name": "fixed-network", "ipam": {"config": [{"subnet": "10.9.0.0/24"}]}}},
    }
    (setup / "docker-compose.yml").write_text(yaml.safe_dump(compose))
    state = {"id": "ready", "type": "service-state", "requirement": "server", "service": "victim", "expected": "running"}
    data = {
        "schema_version": 1, "id": "software.fixture", "category": "software", "description": "test fixture",
        "requirements": {"server": {"source": "manual.tex", "section": "Environment Setup", "description": "server ready"}},
        "variants": {"amd64": {"setup": "lab/Labsetup", "architecture": "amd64"}},
        "runtime": {"backend": "compose", "compose": "docker-compose.yml", "services": {"victim": {"role": "daemon"}},
                    "readiness": [state]},
        "checks": [{**state, "id": "still-running"}],
    }
    path = root / "test.yaml"
    path.write_text(yaml.safe_dump(data))
    return root, path, data, compose


def load(fixture_lab, data=None):
    root, path, original, _ = fixture_lab
    if data is not None:
        path.write_text(yaml.safe_dump(data))
    return Manifest(path, "amd64", root=root)


@pytest.mark.parametrize("mutation", ["unknown", "unused", "source-escape", "check-duplicate", "requirement", "role"])
def test_rejects_silent_configuration_errors(fixture_lab, mutation):
    data = copy.deepcopy(fixture_lab[2])
    if mutation == "unknown":
        data["unkown"] = 1
    elif mutation == "unused":
        data["checks"][0]["expect_status"] = 200
    elif mutation == "source-escape":
        data["requirements"]["server"]["source"] = "../manual.tex"
    elif mutation == "check-duplicate":
        data["checks"][0]["id"] = "ready"
    elif mutation == "requirement":
        data["checks"][0]["requirement"] = "absent"
    else:
        data["runtime"]["services"]["victim"]["role"] = "oneshot"
    with pytest.raises(ManifestError):
        load(fixture_lab, data)


def test_duplicate_yaml_key(fixture_lab):
    root, path, _, _ = fixture_lab
    path.write_text(path.read_text() + "id: another\n")
    with pytest.raises(ManifestError, match="duplicate YAML key"):
        Manifest(path, "amd64", root=root)


def test_broken_symlink_is_an_error(fixture_lab):
    manifest = load(fixture_lab)
    (manifest.setup / "missing-context").symlink_to("absent")
    with pytest.raises(ManifestError, match="broken symlink"):
        manifest.static()


def test_nested_symlinks_cannot_escape_or_cycle(fixture_lab, tmp_path):
    manifest = load(fixture_lab)
    shared = manifest.root / "shared"
    shared.mkdir()
    (manifest.setup / "shared").symlink_to(shared)
    nested = shared / "external"
    nested.symlink_to(tmp_path)
    with pytest.raises(ManifestError, match="leaves repository"):
        manifest.static()
    nested.unlink()
    nested.symlink_to(shared)
    with pytest.raises(ManifestError, match="cycle"):
        manifest.static()


def test_prepare_isolates_names_and_preserves_source(fixture_lab, tmp_path, monkeypatch):
    manifest = load(fixture_lab)
    original = (manifest.setup / "docker-compose.yml").read_bytes()
    runner = Runner(manifest, tmp_path / "run")
    cfg = copy.deepcopy(fixture_lab[3])
    cfg["services"]["victim"]["build"] = {"context": str(runner.setup)}
    monkeypatch.setattr(runner, "docker", lambda args, timeout=60: (0, json.dumps(cfg), "fake-log", 0))
    runner.prepare()
    generated = yaml.safe_load(runner.compose.read_text())
    victim = generated["services"]["victim"]
    assert victim["container_name"].startswith(runner.project)
    assert victim["image"].startswith(runner.project)
    assert generated["networks"]["lan"]["name"].startswith(runner.project)
    assert victim["networks"]["lan"]["ipv4_address"] == "10.9.0.5"
    assert (manifest.setup / "docker-compose.yml").read_bytes() == original


def test_subnet_conflict_blocks_without_startup(fixture_lab, tmp_path, monkeypatch):
    runner = Runner(load(fixture_lab), tmp_path / "run")
    runner.compose.write_text(yaml.safe_dump(fixture_lab[3]))
    def docker(args, timeout=60):
        output = "abc" if args[1] == "ls" else json.dumps([
            {"Name": "user-lab", "Labels": {}, "IPAM": {"Config": [{"Subnet": "10.9.0.0/16"}]}}])
        return 0, output, "fake-log", 0
    monkeypatch.setattr(runner, "docker", docker)
    with pytest.raises(Blocked, match="user-lab"):
        runner.check_subnets()
    assert not runner.state["up_attempted"]


@pytest.mark.parametrize("failure", [CheckFailure("failed up"), KeyboardInterrupt("cancelled")])
def test_partial_startup_failure_always_collects_and_cleans(fixture_lab, tmp_path, monkeypatch, failure):
    runner = Runner(load(fixture_lab), tmp_path / "run")
    monkeypatch.setattr(runner, "lock", lambda: (tmp_path / "lock").open("w"))
    called = []
    for name in ("preflight", "prepare", "build"):
        monkeypatch.setattr(runner, name, lambda: "ok")
    def up():
        runner.state["up_attempted"] = True
        raise failure
    def collect():
        called.append("collect")
        raise RuntimeError("collection also failed")
    monkeypatch.setattr(runner, "up", up)
    monkeypatch.setattr(runner, "collect", collect)
    monkeypatch.setattr(runner, "down", lambda: called.append("down") or "cleaned")
    assert runner.run("all") in (1, 130)
    assert called == ["collect", "down"]
    assert (runner.run_dir / "junit.xml").is_file()


def test_successful_lifecycle_reaches_assertions_and_returns_zero(fixture_lab, tmp_path, monkeypatch):
    runner = Runner(load(fixture_lab), tmp_path / "run")
    monkeypatch.setattr(runner, "lock", lambda: (tmp_path / "lock").open("w"))
    called = []
    for name in ("preflight", "prepare", "build"):
        monkeypatch.setattr(runner, name, lambda: "ok")
    def up():
        runner.state["up_attempted"] = True
        return "started"
    monkeypatch.setattr(runner, "up", up)
    monkeypatch.setattr(runner, "probe", lambda check: {"actual": "running"})
    monkeypatch.setattr(runner, "collect", lambda: called.append("collect") or "collected")
    monkeypatch.setattr(runner, "down", lambda: called.append("down") or "cleaned")
    assert runner.run("all") == 0
    assert any(r["id"] == "still-running" and r["status"] == "PASS" for r in runner.results)
    assert called == ["collect", "down"]
    summary = json.loads((runner.run_dir / "results.json").read_text())
    assert summary["status"] == "PASS"
    assert summary["not_run"] == []


def test_existing_mode_cannot_mutate_environment(fixture_lab, tmp_path):
    runner = Runner(load(fixture_lab), tmp_path / "run", "existing", "user-project")
    for command in ("prepare", "build", "up", "down"):
        with pytest.raises(ManifestError, match="forbidden"):
            runner.run(command)


def test_file_identity_failure_is_detected(fixture_lab, tmp_path, monkeypatch):
    runner = Runner(load(fixture_lab), tmp_path / "run", "existing", "user-project")
    wrong_hash = hashlib.sha256(b"wrong file").hexdigest()
    monkeypatch.setattr(runner, "dc", lambda args, timeout=60: (0, f"{wrong_hash} /file", "fake-log", 0))
    with pytest.raises(CheckFailure, match="deployed file differs"):
        runner.probe({"type": "file", "service": "victim", "path": "/file", "source": "identity"})


def test_http_checks_status_content_headers_and_host(fixture_lab, tmp_path):
    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()
            self.wfile.write(self.headers["Host"].encode())
        def log_message(self, *args):
            pass
    server = HTTPServer(("127.0.0.1", 0), Handler)
    worker = threading.Thread(target=server.serve_forever, daemon=True)
    worker.start()
    runner = Runner(load(fixture_lab), tmp_path / "run")
    check = {"id": "http", "type": "http", "requirement": "server", "url": f"http://lab.invalid:{server.server_port}/",
             "connect_address": "127.0.0.1", "expect_status": 200,
             "body_contains": "lab.invalid", "expected_headers": {"Content-Type": "text/plain"}}
    try:
        assert runner.probe(check)["http_status"] == 200
        runner.manifest.data["checks"] = [check]
        runner.checks("check")
        assert runner.results[-1]["status"] == "PASS"
        assert runner.results[-1]["http_status"] == 200
        for field, value in (("expect_status", 201), ("body_contains", "missing"), ("expected_headers", {"Content-Type": "application/json"})):
            with pytest.raises(CheckFailure):
                runner.probe({**check, field: value})
    finally:
        server.shutdown()
        server.server_close()
        worker.join()


def test_stderr_warning_does_not_corrupt_json(fixture_lab, tmp_path):
    runner = Runner(load(fixture_lab), tmp_path / "run")
    result = runner.command(["python3", "-c", "import sys; print('{}'); print('warning', file=sys.stderr)"], cwd=runner.manifest.root)
    assert json.loads(result[1]) == {}
    assert "warning" in (runner.run_dir / result[2]).read_text()


def test_subprocess_timeout_is_recorded(fixture_lab, tmp_path):
    runner = Runner(load(fixture_lab), tmp_path / "run")
    with pytest.raises(subprocess.TimeoutExpired):
        runner.command(["python3", "-c", "import time; time.sleep(30)"], cwd=runner.manifest.root, timeout=0.1)
    assert "STDERR:" in (runner.run_dir / "logs/0001.txt").read_text()


def test_wrong_native_architecture_is_blocked(fixture_lab, tmp_path, monkeypatch):
    runner = Runner(load(fixture_lab), tmp_path / "run")
    monkeypatch.setattr(runner, "docker", lambda args: (0, json.dumps({"Architecture": "aarch64"}), "fake-log", 0))
    with pytest.raises(Blocked, match="requires native amd64"):
        runner.preflight()


def test_all_registered_variants_validate():
    for path in (TESTING / "manifests").rglob("*.yaml"):
        for variant in yaml.safe_load(path.read_text())["variants"]:
            Manifest(path, variant).static()
