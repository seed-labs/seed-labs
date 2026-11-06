# SEED Lab environment acceptance

This framework checks whether a lab setup supplies the environment described in
its manual. It does not solve lab tasks, generate attack payloads, or establish
that an exploit succeeds. Local runs and GitHub Actions use the same YAML
manifests, CLI, lifecycle, and reports.

The initial implementation supports local Linux Docker Compose environments.
Shellshock is the first registered lab, with amd64 and arm64 variants. VM,
kernel-specific, and browser backends are not implemented yet. An unregistered
lab is not covered by a successful workflow.

## Local setup

Use Python 3.10 or newer, Docker Engine, and the Docker Compose plugin in Linux
(including a Linux VM or WSL). The current backend requires a local Docker socket
and native architecture. It does not claim Docker Desktop, remote Docker, or
QEMU user-mode emulation compatibility.

From the repository root:

```sh
python3 -m venv lab-setup/testing/.venv
lab-setup/testing/.venv/bin/python -m pip install -r lab-setup/testing/requirements.txt
```

The current user must be able to access Docker. The CLI does not invoke sudo or
change Docker socket permissions. Test execution does not require a GitHub
account, token, or GitHub environment variables. Initial dependency installation
and uncached image builds require network access.

```sh
# Pure input validation: no daemon connection or filesystem changes.
lab-setup/testing/.venv/bin/python lab-setup/testing/run.py validate \
  lab-setup/testing/manifests/software/shellshock.yaml --variant amd64

# Docker and native architecture prerequisites; saves an environment report.
lab-setup/testing/.venv/bin/python lab-setup/testing/run.py preflight \
  lab-setup/testing/manifests/software/shellshock.yaml --variant amd64

# Full isolated lifecycle, including evidence collection and teardown.
lab-setup/testing/.venv/bin/python lab-setup/testing/run.py all \
  lab-setup/testing/manifests/software/shellshock.yaml --variant amd64
```

On a native arm64 Linux machine, select `--variant arm64`. The CLI deliberately
reports BLOCKED on the wrong native architecture rather than silently emulating.

Default output is a unique directory under `lab-setup/testing/artifacts/`. Use
`--run-dir PATH` to choose a directory. Use a new directory for each fresh full
run; existing directories preserve run identity and result history.

## Lifecycle and debugging

```text
validate → preflight → prepare → build → up → readiness → check
                                             ↓
                                      collect → down
```

`prepare` copies the setup and explicitly declared repository dependencies into
the run workspace, materializing valid symlinks as the downloadable lab archive
does. It executes only the manifest's declared argument-vector preparation steps
and checks their declared outputs. It never repairs source files or silently
installs missing host prerequisites.

Managed runs give containers, networks, named volumes, and built image tags
unique names. The lab's IP addresses, subnets, service keys, binaries, and
application configuration are preserved. Subnet collisions with existing Docker
networks block startup; the framework does not delete those networks or rewrite
lab addresses. Commands are serialized on the local machine.

All Compose services must declare a role: `daemon`, `oneshot`, or `build-only`.
Daemon and one-shot roles require corresponding readiness state assertions;
build-only services are built but not explicitly started.

For step-by-step debugging, use the same manifest, variant, and run directory:

```sh
python lab-setup/testing/run.py prepare lab-setup/testing/manifests/software/shellshock.yaml --run-dir /tmp/seed-shellshock
python lab-setup/testing/run.py build lab-setup/testing/manifests/software/shellshock.yaml --run-dir /tmp/seed-shellshock
python lab-setup/testing/run.py up lab-setup/testing/manifests/software/shellshock.yaml --run-dir /tmp/seed-shellshock
python lab-setup/testing/run.py readiness lab-setup/testing/manifests/software/shellshock.yaml --run-dir /tmp/seed-shellshock
python lab-setup/testing/run.py check lab-setup/testing/manifests/software/shellshock.yaml --run-dir /tmp/seed-shellshock
python lab-setup/testing/run.py collect lab-setup/testing/manifests/software/shellshock.yaml --run-dir /tmp/seed-shellshock
python lab-setup/testing/run.py down lab-setup/testing/manifests/software/shellshock.yaml --run-dir /tmp/seed-shellshock
```

These commands use the activated virtual environment's `python`. Run `preflight`
before a manual lifecycle. Individual stages do not automatically tear down a
debugging environment; `all` does. `up` starts services; `readiness` separately
waits for them. On failure, Ctrl-C, or SIGTERM, `all` attempts collection and
teardown, preserving the original error even if collection also fails. SIGKILL
or a machine crash cannot execute cleanup; reuse the saved run directory with
`down` after restarting. Built images, workspace, and reports are retained for
inspection; teardown removes only this run's Compose containers, networks, and
volumes.

Managed mode does not currently support external Docker networks/volumes,
out-of-workspace bind mounts, or rewriting Dockerfile `FROM` references to
locally built base images. Labs requiring ordered local base-image builds need
an explicit future build adapter, not a claim of generic support.

## Checking an already running setup

```sh
python lab-setup/testing/run.py all \
  lab-setup/testing/manifests/software/shellshock.yaml \
  --variant amd64 --mode existing --project YOUR_COMPOSE_PROJECT
```

Existing mode uses the original Compose entry and the supplied project name. It
checks prerequisites, readiness, assertions, and collects evidence. It does not
prepare, build, start, stop, or remove the user's environment. Probe commands
still execute inside containers and HTTP probes issue ordinary requests. Only
use manifests whose probes you have reviewed. The manifest must describe the
actual setup being inspected.

## Manifest contract

See [schema.yaml](schema.yaml) and
[the Shellshock manifest](manifests/software/shellshock.yaml).

- `schema_version: 1` identifies the format; unknown and duplicate YAML keys
  fail validation, as do fields unused by the selected probe type.
- `requirements` links assertions to repository manual files, sections, and
  requirement descriptions. Descriptions and expected values require review;
  they are not automatically derived from the configuration being tested.
- `variants` identifies setup paths and required native architecture.
- `dependencies` lists additional repository paths to stage, when necessary.
- `prepare` contains `argv`, optional `cwd` and `timeout`, and required
  `expected` output paths. `build.timeout` bounds Compose builds.
- `runtime` declares the Compose entry, every service's role, and readiness
  probes. `checks` contains independent environment assertions.
- Probe IDs are stable and unique across readiness and checks. Each references
  a declared requirement. Required checks default to true.

Setup paths, dependency paths, and requirement sources are relative to the
repository root. Compose paths, preparation working directories and expected
outputs, and file-comparison sources are relative to the selected setup root.
Path escapes and broken or external symlinks fail validation.

Supported probes are `service-state`, `container-ip`, `exec` (argument vector,
expected exit, optional stdout text), `file` (deployed SHA-256 identity and
optional executable permission), and `http` (status, body, and headers).
Readiness can use bounded retries; acceptance assertions default to one attempt.
Unknown probe types fail validation. Complex custom Python test programs and
additional typed probes will be introduced when an individual lab needs them.

HTTP probes use ordinary GET requests without ambient HTTP proxy settings or
automatic redirects. `connect_address` explicitly supplies a per-probe address
while retaining the URL's HTTP Host header. For Shellshock this implements the
manual's mapping in the test client without changing `/etc/hosts`. It validates
address reachability and host handling, **not the user's system DNS/hosts file or
browser**. File identity verifies deployment of the supplied interpreter and
scripts; it does not prove the interpreter is exploitable.

## Results and CI

The run directory contains:

- `results.json`, `junit.xml`, `summary.md`: structured results and a human report.
- `manifest.yaml`, `state.json`, `environment.json`: manifest snapshot, run
  ownership, and observed Docker/host platform facts.
- `logs/`: command arguments, separate stdout/stderr, and combined diagnostic logs.
- HTTP response evidence, service logs, container state/networks, and image IDs
  when an environment was started or inspected.

Check outcomes remain PASS or FAIL, including optional failures. Lifecycle
problems can be BLOCKED (missing platform or conflicting network) or ERROR
(framework/infrastructure problem). Exit codes are 0 for required checks passing,
1 for acceptance/build/start failure, 2 for blocked/invalid/infrastructure errors,
and 130 for interruption. Reports retain previous stage outcomes when a run
directory is reused. A passing optional policy does not erase a failed check.

[The GitHub workflow](../../.github/workflows/labsetup.yml) runs framework tests,
generates its matrix from validated manifests, and invokes the same `all`
command on native amd64/arm64 Linux runners. Reports are uploaded even on failure;
a separate cleanup step retries teardown. Currently it runs all registered
manifests on PRs, pushes to master/main, weekly schedules, and manual dispatch.
Changed-dependency selection and VM runners are future work.

To run framework tests locally:

```sh
python -m pip install -r lab-setup/testing/requirements-dev.txt
python -m pytest -q lab-setup/testing/tests
```

The tests use temporary fixtures and a loopback HTTP server, not a Docker daemon.
They cover invalid contracts, input failures, workspace isolation, subnet
conflicts, partial-start failure/cancellation cleanup, existing-mode restrictions,
failed identity and HTTP assertions, subprocess timeout, and stdout/stderr
separation.
