"""Run manifest cases serially and preserve partial evidence after failures."""
import json
import signal
from pathlib import Path

import yaml

from .manifest import Manifest, TESTING
from .runner import Runner


def run_suite(run_dir, variant, categories=(), tun_device=None):
    run_dir = Path(run_dir).resolve()
    run_dir.mkdir(parents=True, exist_ok=True)
    summary = {"variant": variant, "cases": [], "not_applicable": [], "status": "RUNNING"}
    code = 0
    def interrupted(signum, frame):
        raise KeyboardInterrupt(f"signal {signum}")
    previous = signal.signal(signal.SIGTERM, interrupted)
    try:
        for path in sorted((TESTING / "manifests").rglob("*.yaml")):
            data = yaml.safe_load(path.read_text())
            if categories and data["category"] not in categories:
                continue
            if variant not in data["variants"]:
                summary["not_applicable"].append({"lab": data["id"], "available_variants": list(data["variants"])})
                continue
            print(f"\n=== {data['id']} / {variant} ===", flush=True)
            directory = run_dir / (data["id"] + "-" + variant)
            try:
                runner = Runner(Manifest(path, variant), directory, tun_device=tun_device)
                result = runner.run("all")
                report = json.loads((directory / "results.json").read_text())
                status = report["status"]
            except KeyboardInterrupt:
                raise
            except Exception as exc:
                result, status = 2, "ERROR"
                (directory / "suite-error.txt").parent.mkdir(parents=True, exist_ok=True)
                (directory / "suite-error.txt").write_text(str(exc) + "\n")
            summary["cases"].append({"lab": data["id"], "variant": variant, "status": status,
                                     "exit_code": result, "artifacts": str(directory)})
            code = 130 if result == 130 else (code or result)
            (run_dir / "suite.json").write_text(json.dumps(summary, indent=2) + "\n")
            if result == 130:
                break
    except KeyboardInterrupt:
        code = 130
    finally:
        summary["status"] = "INTERRUPTED" if code == 130 else ("FAIL" if code else ("PASS" if summary["cases"] else "EMPTY"))
        (run_dir / "suite.json").write_text(json.dumps(summary, indent=2) + "\n")
        signal.signal(signal.SIGTERM, previous)
    return code if code or summary["cases"] else 2
