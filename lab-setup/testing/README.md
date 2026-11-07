# SEED Lab setup testing

Use this test runner to check whether a lab setup provides the initial environment
required by its manual. Checks cover deployment, service readiness, configuration,
tools, and ordinary network or application behavior. They do not carry out attacks
or complete student exercises.

See the coverage references for individual labs:

- [Software security](docs/software_security.md)
- [Network security](docs/network_security.md)
- [Web security](docs/web_security.md)

## Files and directories

| Path | Purpose |
| --- | --- |
| `run.py` | Command-line entry point for local runs and CI |
| `requirements.txt` | Python dependencies for the complete lab test suite |
| `docs/` | Per-category test scope and prerequisite references |
| `manifests/` | Per-lab prerequisites, setup paths, and acceptance checks |
| `testing/` | Lifecycle management, probes, and report generation |
| `tools/` | Small UID, TLS, and libpcap capability-check programs |
| `artifacts/` | Generated run evidence; excluded from version control |

The programs in `tools/` check host capabilities: `uid_check.c` prints real and
effective UIDs, `tls_check.c` creates and frees an OpenSSL TLS context, and
`pcap_check.c` checks libpcap linking and reports its version. They are compiled
with the host compiler in the run workspace.

Source-only labs execute directly on the host. Labs with a supplied Compose
setup use Docker for those lab services; the runner starts and cleans them up.
There are no auxiliary compiler images or replacement test containers.

## Requirements

- Linux and Python 3.10 or newer.
- Docker Engine, the Docker Compose plugin, and local Docker socket access for
  labs that supply container setups.
- A native CPU architecture matching the selected manifest variant: `amd64` or
  `arm64`.
- The host commands and development libraries listed in the manifest's `host`
  section. Depending on the case, these include gcc, make, nasm, gdb, zsh,
  OpenSSL headers, libpcap headers, and amd64 32-bit development libraries.
- An ordinary user account with noninteractive `sudo` for cases that check
  Set-UID behavior or root administration.
- Network access for installing dependencies and downloading uncached lab images.

Run commands from the repository root. The runner checks the existing host and
does not install missing system prerequisites. A Linux VM or WSL environment can
be used when it provides the required host capabilities and, for Compose labs,
reachable local Docker networks. Remote Docker daemons, Docker Desktop, and CPU
emulation are outside the supported setup.

Host-built programs copied into lab containers must be compatible with those
containers' runtime libraries. The runner uses the supplied Makefiles and images;
it does not change them to work around a host compiler or libc mismatch.

Some labs have additional prerequisites:

- [Emulator-based labs](#emulator-based-labs) require the Emulator dependencies and
  an SDK checkout.
- [TUN-based labs](#tun-based-labs) require a working TUN device.
- ICMP Redirect requires the legacy Docker environment that accepts the
  interface-specific sysctl entries in its supplied Compose file.

A local run does not require a GitHub account or token.

## Installation

Use an existing Python environment or create a virtual environment:

```sh
python3 -m venv lab-setup/testing/.venv
. lab-setup/testing/.venv/bin/activate
python -m pip install -r lab-setup/testing/requirements.txt
```

The commands below use `python` from the active environment. Other environment
managers can be used with the same dependencies and commands. An optional
[uv setup](#using-uv-optional) is provided below.

## Select a test

Each YAML manifest identifies a lab setup, its supported architecture variants,
prerequisites, and acceptance checks. The coverage references above link to the
manifests. To list the available test manifests:

```sh
find lab-setup/testing/manifests -name '*.yaml' | sort
```

Select `--variant amd64` on an amd64 machine or `--variant arm64` on an ARM64
machine. Only variants listed in the selected manifest are available. A native
architecture mismatch blocks the run.

## Run one lab

For example, to test the SQL Injection lab environment:

```sh
python lab-setup/testing/run.py all \
  lab-setup/testing/manifests/web/sql_injection.yaml --variant amd64
```

The `all` command validates inputs, checks prerequisites, prepares a working
copy in the run directory, runs preparation commands on the host, and checks acceptance conditions.
For Compose cases it also builds and starts the supplied lab services, collects
evidence, and removes the run's containers, networks, and named volumes. Host-only
cases do not connect to Docker or start containers.

The lab's addresses and application settings are preserved. Conflicting Docker
subnets block startup. Runs on the same machine are serialized.

Results are saved in a unique directory under `lab-setup/testing/artifacts/`.
Use `--run-dir PATH` to select another location. Choose a new directory for each
fresh full run. Existing directories retain their run identity and history.

## Run multiple labs

Install any additional prerequisites for the selected labs before running a
suite. The full suite includes Emulator and TUN cases, which require the
additional setup described below. To run all cases available for the machine's architecture:

```sh
python lab-setup/testing/run.py suite --variant amd64
```

To select a category:

```sh
python lab-setup/testing/run.py suite --variant amd64 --category web
```

Repeat `--category` to select multiple categories. The suite runs cases serially,
keeps per-case evidence and a `suite.json` index, and continues after a case
failure. Cases without the requested variant are listed as not applicable.

## Emulator-based labs

Python dependencies for BGP Exploration, DNS Infrastructure, and Morris Worm are
included in `requirements.txt`. These labs also require a SEED Emulator checkout
containing the `emulator.revision` commit listed in the lab manifest:

```sh
export SEED_EMULATOR_SOURCE=/path/to/seed-emulator
```

The default location is `../seed-emulator`, relative to this repository. The
runner uses an archive of the required commit; uncommitted SDK changes are not
used. Review the lab manifest for the generated topology and resource needs.

The supplied Internet Map configuration mounts the host Docker socket. This
mount is explicitly allowed by the relevant manifests.

## TUN-based labs

VPN and tunnel labs require a working `/dev/net/tun`. The checks create and close
temporary, nonpersistent TUN interfaces on the host or in the lab containers, as
specified by the case.

If the device is available at another host path, supply it explicitly:

```sh
python lab-setup/testing/run.py all \
  lab-setup/testing/manifests/network/vpn_tunnel.yaml --variant amd64 \
  --tun-device /path/to/tun
```

The alternative path must be a real TUN character device with major/minor
numbers 10:200. The runner records the mapping. It does not create host device
nodes; a regular file cannot be used as a substitute.

## Inspect failures and clean up

Start with `summary.md` and `results.json` in the run directory. Command output is
stored separately in `logs/`; HTTP and TCP probes also save response evidence.

For individual stages, reuse the same manifest, variant, and run directory:

```sh
lab_manifest=lab-setup/testing/manifests/web/sql_injection.yaml
lab_run=lab-setup/testing/artifacts/sql-debug

python lab-setup/testing/run.py validate "$lab_manifest" --variant amd64
python lab-setup/testing/run.py preflight "$lab_manifest" --variant amd64 --run-dir "$lab_run"
python lab-setup/testing/run.py prepare "$lab_manifest" --variant amd64 --run-dir "$lab_run"
python lab-setup/testing/run.py build "$lab_manifest" --variant amd64 --run-dir "$lab_run"
python lab-setup/testing/run.py up "$lab_manifest" --variant amd64 --run-dir "$lab_run"
python lab-setup/testing/run.py readiness "$lab_manifest" --variant amd64 --run-dir "$lab_run"
python lab-setup/testing/run.py check "$lab_manifest" --variant amd64 --run-dir "$lab_run"
python lab-setup/testing/run.py collect "$lab_manifest" --variant amd64 --run-dir "$lab_run"
python lab-setup/testing/run.py down "$lab_manifest" --variant amd64 --run-dir "$lab_run"
```

Inspect a failed stage before continuing. Individual stages leave the debugging
environment available until `down` is run. The `all` command attempts evidence
collection and cleanup on failure, Ctrl-C, or SIGTERM. After a machine crash or
forced termination, use `down` with the saved run directory.

Some supplied Makefiles and Set-UID probes need `sudo` to change permissions on
compiled files. Builds use a private workspace. Cleanup removes Set-UID/Set-GID
bits from declared build outputs, including after a failed preparation step.
Host `/etc/hosts`, ASLR, `/bin/sh`, and other system settings remain unchanged.

Cleanup removes only resources belonging to that run. Lab images, staged
files, and reports remain available for inspection. The original repository
setup is preserved. Keep the manifest unchanged while reusing a run directory.

## Check an existing environment

For a setup already running under Docker Compose:

```sh
python lab-setup/testing/run.py all \
  lab-setup/testing/manifests/web/sql_injection.yaml \
  --variant amd64 --mode existing --project YOUR_COMPOSE_PROJECT
```

Existing mode applies to Compose setups. The manifest must match the deployed
setup. Existing mode checks prerequisites,
readiness, and acceptance conditions and collects evidence. It does not build,
start, stop, or remove the existing environment. Probes execute commands inside
containers and issue ordinary requests; review the manifest before using it.

## Reports and exit codes

| File or directory | Contents |
| --- | --- |
| `summary.md` | Human-readable check summary |
| `results.json` | Detailed check outcomes and references to evidence |
| `junit.xml` | Results for JUnit-compatible tools |
| `manifest.yaml` | Manifest snapshot |
| `state.json`, `environment.json` | Run identity and observed environment facts |
| `host-files.json` | Metadata and hashes of declared host build outputs |
| `logs/` | Command arguments, stdout, stderr, and diagnostic logs |
| Probe evidence files | HTTP responses, login checks, and ordinary TCP request traces |

Check outcomes are `PASS` or `FAIL`. Prerequisite and lifecycle problems can be
reported as `BLOCKED` or `ERROR`. Optional failures remain visible in reports.

| Exit code | Meaning |
| --- | --- |
| `0` | Required checks passed |
| `1` | Acceptance, build, or startup failure |
| `2` | Missing prerequisites, invalid input, or infrastructure error |
| `130` | Interrupted run |

A successful run covers only its selected manifest and variant. It does not
establish that other labs, architectures, or completed student exercises work.

## GitHub Actions

The [GitHub Actions workflow](../../.github/workflows/labsetup.yml) reads its matrix
from the manifests and uses the same test runner as local execution. Runner
machines must meet the architecture and lab-specific prerequisites described
above. CI installs each case's declared Ubuntu host packages directly on its
runner before testing; local runs only check prerequisites. The workflow runs on
pull requests, pushes to master/main, scheduled runs,
and manual dispatch.

Each job uploads its check reports and command logs. Staged workspaces and
runtime database storage are excluded from uploaded artifacts. A cleanup step
also attempts to remove resources after a failed or interrupted run.

## Using uv (optional)

uv can create the same virtual environment and install the requirements:

```sh
uv venv lab-setup/testing/.venv
uv pip install --python lab-setup/testing/.venv/bin/python -r lab-setup/testing/requirements.txt
. lab-setup/testing/.venv/bin/activate
```

Once the environment is active, use the same `python` commands shown above.
