"""Environment probes for native software labs; no exploit payloads."""
from datetime import datetime, timezone
import json
import socket
import time
import uuid

from .binary import elf_metadata
from .errors import CheckFailure
from .format_input import normal_trace
from .format_input import buffer_trace
from .manifest import inside


PROCESS_UID = r'''
for p in /proc/[0-9]*; do
    if [ "$(readlink "$p/exe" 2>/dev/null)" = "$1" ]; then
        printf '%s ' "${p##*/}"
        sed -n 's/^Uid:[[:space:]]*//p' "$p/status"
    fi
done
'''


def software_probe(runner, check):
    if check["type"] == "elf":
        try:
            actual = elf_metadata(inside(runner.setup, check["source"]))
        except ValueError as exc:
            raise CheckFailure(str(exc)) from exc
        expected = {k: check[k] for k in ("elf_class", "machine", "static", "executable_stack") if k in check}
        if any(actual[k] != value for k, value in expected.items()):
            raise CheckFailure(f"ELF {check['source']}: observed {actual}, expected {expected}")
        return {"source": check["source"], "actual": actual, "expected": expected}
    if check["type"] == "process-uid":
        text = runner.successful(runner.dc([
            "exec", "-T", check["service"], "sh", "-c", PROCESS_UID, "sh", check["path"],
        ], check.get("timeout", 10)))
        processes = []
        for line in text.splitlines():
            fields = line.split()
            if len(fields) != 5 or not all(f.isdigit() for f in fields):
                raise CheckFailure(f"cannot interpret process UID row: {line}")
            processes.append({"pid": int(fields[0]), "real_uid": int(fields[1]), "effective_uid": int(fields[2])})
        if not processes:
            raise CheckFailure(f"no running process executes {check['path']}")
        if any(p["effective_uid"] != check["expected_euid"] for p in processes):
            raise CheckFailure(f"unexpected process privileges: {processes}")
        return {"processes": processes, "expected_euid": check["expected_euid"]}
    return format_input(runner, check)


def format_input(runner, check):
    """Exercise two sequential ordinary requests and correlate fresh console logs."""
    info = runner.inspect_service(check["service"])
    container_id = info["Id"]
    timeout = check.get("timeout", 15)
    evidence = {"service": check["service"], "host": check["host"], "port": check["port"], "requests": []}
    path = runner.run_dir / f"tcp-{check['id']}.json"
    try:
        for index in range(check.get("requests", 2)):
            marker = f"SEED_ENV_{uuid.uuid4().hex}_{index}"
            # NUL terminates printf's input; SHUT_WR lets fread finish before 1500 bytes.
            payload = (f"t{index}".encode() + b"\0") if check["type"] == "buffer-input" else (marker + "\n").encode("ascii") + b"\0"
            since = datetime.now(timezone.utc).isoformat()
            deadline = time.monotonic() + timeout
            while True:
                try:
                    connection = socket.create_connection((check["host"], check["port"]), timeout=max(0.01, deadline - time.monotonic()))
                    break
                except OSError:
                    if time.monotonic() >= deadline:
                        raise
                    time.sleep(0.2)
            with connection:
                connection.sendall(payload)
                connection.shutdown(socket.SHUT_WR)
            request = {"marker": marker, "sent_bytes": len(payload)}
            evidence["requests"].append(request)
            while True:
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    raise CheckFailure(f"no complete normal-input trace for {marker}; see {path.name}")
                result = runner.docker(["logs", "--timestamps", "--since", since, container_id], timeout=min(5, remaining))
                logs = runner.successful(result)
                stderr = (runner.run_dir / result[2]).with_suffix(".stderr")
                if stderr.is_file():
                    # Docker separates the container's stdout/stderr. Restore the
                    # timestamp order before correlating one request's full trace.
                    other = stderr.read_text(errors="replace")
                    if other:
                        logs = "\n".join(sorted((logs + "\n" + other).splitlines(),
                                                key=lambda line: line.partition(" ")[0])) + "\n"
                request["console_log"] = logs
                try:
                    trace = buffer_trace(logs, len(payload)) if check["type"] == "buffer-input" else normal_trace(logs, marker, len(payload))
                except ValueError as exc:
                    raise CheckFailure(f"{exc}; see {path.name}") from exc
                if trace:
                    request.update(trace)
                    break
                time.sleep(min(0.2, max(0, deadline - time.monotonic())))
        after = runner.inspect_service(check["service"])
        if (after["Id"] != container_id or after["State"]["Status"] != "running"
                or after.get("RestartCount", 0) != info.get("RestartCount", 0)
                or after["State"].get("StartedAt") != info["State"].get("StartedAt")):
            raise CheckFailure("server container stopped or was replaced while processing normal input")
        return {"requests_completed": len(evidence["requests"]), "evidence": path.name}
    finally:
        path.write_text(json.dumps(evidence, indent=2) + "\n")
