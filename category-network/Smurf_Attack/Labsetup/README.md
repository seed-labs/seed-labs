# Smurf and Fraggle Lab Emulator

This folder contains the SEED emulator setup for the Smurf and Fraggle attack
lab.

The emulator uses `Makers.makeEmulatorBaseWith5StubASAndHosts(1)` to create a
small Internet with five stub ASes, then customizes three roles:

- AS-150: attacker host
- AS-151: victim host
- AS-152: amplifier LAN with directed broadcast enabled

The amplifier LAN contains multiple hosts. Each amplifier host is configured to
reply to ICMP broadcast echo requests and to run a small UDP responder for the
Fraggle experiment.

## Build

Run the emulator builder from this folder:

```bash
python3 emulator.py --platform amd
```

For Apple Silicon or ARM machines:

```bash
python3 emulator.py --platform arm
```

The generated Docker files are placed in `output/` by default.

The builder imports the SEED emulator package. It works if `seedemu` is
installed in Python, or if the `seed-emulator` repository is checked out next to
this `seed-labs` repository.

## Useful Options

```bash
python3 emulator.py --amplifier-hosts 20
python3 emulator.py --hosts-per-as 1
python3 emulator.py --fraggle-port 7000
```

The attacker host has `python3`, Scapy, and `tcpdump` installed. Students are
expected to write their own Smurf and Fraggle packet-sending programs during
the lab.

The victim host has `netcat-openbsd` installed, so students can listen for
Fraggle replies and print their payloads with a simple command such as:

```bash
nc -ul 7000
```

The UDP responder installed on amplifier hosts is:

- `/opt/smurf-lab/fraggle_amplifier.py`
