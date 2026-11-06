import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import signal
import uuid

import yaml

from .manifest import Manifest, ManifestError, TESTING
from .runner import Runner, Blocked

COMMANDS = ("validate", "preflight", "prepare", "build", "up", "readiness", "check", "collect", "down", "all", "matrix")


def main(argv=None):
    parser = argparse.ArgumentParser(description="SEED lab environment acceptance (local and CI)")
    parser.add_argument("command", choices=COMMANDS)
    parser.add_argument("manifest", nargs="?", type=Path)
    parser.add_argument("--variant", default="amd64")
    parser.add_argument("--run-dir", type=Path, help="reuse this directory for step-by-step commands")
    parser.add_argument("--mode", choices=("managed", "existing"), default="managed")
    parser.add_argument("--project", help="existing Compose project name; required in existing mode")
    args = parser.parse_args(argv)
    try:
        if args.command == "matrix":
            include = []
            for path in sorted((TESTING / "manifests").rglob("*.yaml")):
                data = yaml.safe_load(path.read_text())
                for variant in data["variants"]:
                    manifest = Manifest(path, variant)
                    manifest.static()
                    include.append({"manifest": str(path.relative_to(manifest.root)), "variant": variant,
                                    "runner": "ubuntu-24.04-arm" if manifest.config["architecture"] == "arm64" else "ubuntu-24.04"})
            print(json.dumps({"include": include}))
            return 0
        if not args.manifest:
            parser.error("manifest is required")
        manifest = Manifest(args.manifest, args.variant)
        if args.command == "validate":
            print(manifest.static())
            return 0
        if args.command not in ("all", "preflight") and not args.run_dir:
            parser.error("step-by-step commands require --run-dir")
        run_dir = args.run_dir or TESTING / "artifacts" / (
            datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ") + "-" + uuid.uuid4().hex[:8])
        runner = Runner(manifest, run_dir, args.mode, args.project)
        # SIGTERM uses the same finally/cleanup path as Ctrl-C.
        def interrupted(signum, frame):
            raise KeyboardInterrupt(f"signal {signum}")
        previous = signal.signal(signal.SIGTERM, interrupted)
        try:
            print(f"Artifacts: {runner.run_dir}", flush=True)
            return runner.run(args.command)
        finally:
            signal.signal(signal.SIGTERM, previous)
    except (ManifestError, Blocked, OSError, ValueError) as exc:
        print(f"ERROR: {exc}")
        return 2
