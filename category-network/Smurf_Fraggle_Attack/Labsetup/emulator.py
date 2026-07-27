#!/usr/bin/env python3
# encoding: utf-8

"""Build the SEED emulator setup for the Smurf/Fraggle attack lab.

The lab uses the Makers utility to create a small Internet with five stub ASes
and customizes several ASes for reflection/amplification experiments:

  AS-150: attacker
  AS-151: victim
  AS-152: amplifier LAN with directed broadcast enabled

The emulator stays focused on the reflection/amplification attack pattern:
directed broadcast, spoofed requests, amplifier hosts, and a victim.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
from typing import List, Optional


SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parents[2]
SEED_EMULATOR_ROOT = REPO_ROOT.parent / "seed-emulator"

for path in [REPO_ROOT, SEED_EMULATOR_ROOT]:
    if str(path) not in sys.path:
        sys.path.insert(0, str(path))

from seedemu.compiler import Docker, Platform
from seedemu.core import Emulator, Node
from seedemu.utilities import Makers


ATTACKER = (150, "host_0")
VICTIM = (151, "host_0")
AMPLIFIER_ASN = 152
AMPLIFIER_ROUTER = "router0"
AMPLIFIER_NETWORK = "net0"
AMPLIFIER_PREFIX = "10.152.0"

AUTO_HOST_START = 71
FIRST_USABLE_HOST = 2
LAST_USABLE_HOST = 253
MAX_AMPLIFIER_HOSTS = LAST_USABLE_HOST - FIRST_USABLE_HOST + 1

LAB_DIR = "/opt/smurf-lab"
FRAGGLE_PORT = 7000


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build the Smurf/Fraggle attack lab emulator.")
    parser.add_argument("--platform", choices=["amd", "arm"], default="amd")
    parser.add_argument("--hosts-per-as", type=int, default=1)
    parser.add_argument(
        "--amplifier-hosts",
        type=int,
        default=12,
        help=f"number of hosts on the AS-152 amplifier LAN (maximum: {MAX_AMPLIFIER_HOSTS})",
    )
    parser.add_argument("--fraggle-port", type=int, default=FRAGGLE_PORT)
    return parser.parse_args()


def resolve_platform(name: str) -> Platform:
    return Platform.AMD64 if name == "amd" else Platform.ARM64


def get_base(emu: Emulator):
    return emu.getLayer("Base")


def get_host(emu: Emulator, asn: int, name: str) -> Node:
    return get_base(emu).getAutonomousSystem(asn).getHost(name)


def get_router(emu: Emulator, asn: int, name: str) -> Node:
    return get_base(emu).getAutonomousSystem(asn).getRouter(name)


def install_file(node: Node, local_name: str, remote_name: Optional[str] = None) -> None:
    remote_name = remote_name or local_name
    content = (SCRIPT_DIR / local_name).read_text(encoding="utf-8")
    node.setFile(f"{LAB_DIR}/{remote_name}", content)


def prepare_lab_dir(node: Node) -> None:
    node.addBuildCommand(f"mkdir -p {LAB_DIR}")
    node.appendStartCommand(f"mkdir -p {LAB_DIR}")


def amplifier_addresses(hosts_per_as: int) -> List[str]:
    """Return free AS-152 host addresses in deterministic allocation order."""
    first_after_base_hosts = AUTO_HOST_START + max(hosts_per_as, 0)
    offsets = list(range(first_after_base_hosts, LAST_USABLE_HOST + 1))
    offsets.extend(range(FIRST_USABLE_HOST, AUTO_HOST_START))
    return [f"{AMPLIFIER_PREFIX}.{offset}" for offset in offsets]


def add_amplifier_hosts(emu: Emulator, amplifier_hosts: int, hosts_per_as: int) -> None:
    if amplifier_hosts < hosts_per_as:
        raise ValueError("--amplifier-hosts must be greater than or equal to --hosts-per-as")

    amplifier_as = get_base(emu).getAutonomousSystem(AMPLIFIER_ASN)
    requested_new_hosts = amplifier_hosts - hosts_per_as
    addresses = amplifier_addresses(hosts_per_as)

    if requested_new_hosts > len(addresses):
        raise ValueError(f"--amplifier-hosts cannot exceed {MAX_AMPLIFIER_HOSTS}")

    for index in range(hosts_per_as, amplifier_hosts):
        address = addresses[index - hosts_per_as]
        amplifier_as.createHost(f"host_{index}").joinNetwork(AMPLIFIER_NETWORK, address=address)


def configure_directed_broadcast_router(router: Node) -> None:
    router.appendStartCommand("sysctl -w net.ipv4.ip_forward=1")
    router.appendStartCommand("sysctl -w net.ipv4.conf.all.bc_forwarding=1 || true")
    router.appendStartCommand("sysctl -w net.ipv4.conf.default.bc_forwarding=1 || true")
    router.appendStartCommand(
        "for f in /proc/sys/net/ipv4/conf/*/bc_forwarding; do "
        "[ -e \"$f\" ] && echo 1 > \"$f\"; done"
    )
    router.appendStartCommand("sysctl -w net.ipv4.conf.all.rp_filter=0")
    router.appendStartCommand("sysctl -w net.ipv4.conf.default.rp_filter=0")
    router.appendClassName("DirectedBroadcastRouter")
    router.setDisplayName("Directed-Broadcast-Router")


def configure_attacker(host: Node) -> None:
    host.addSoftware("python3")
    host.addSoftware("python3-scapy")
    host.addSoftware("tcpdump")
    host.appendClassName("SmurfFraggleAttacker")
    host.setDisplayName("Attacker")


def configure_victim(host: Node) -> None:
    host.addSoftware("tcpdump")
    host.addSoftware("iputils-ping")
    host.addSoftware("netcat-openbsd")
    host.addSoftware("traceroute")
    host.appendClassName("SmurfFraggleVictim")
    host.setDisplayName("Victim")


def configure_amplifier_host(host: Node, fraggle_port: int) -> None:
    host.addSoftware("python3")
    host.addSoftware("tcpdump")
    prepare_lab_dir(host)
    install_file(host, "fraggle_amplifier.py")
    host.appendStartCommand("sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0")
    host.appendStartCommand("sysctl -w net.ipv4.conf.all.rp_filter=0")
    host.appendStartCommand("sysctl -w net.ipv4.conf.default.rp_filter=0")
    host.appendStartCommand(f"chmod +x {LAB_DIR}/fraggle_amplifier.py")
    host.appendStartCommand(
        f"python3 {LAB_DIR}/fraggle_amplifier.py --port {fraggle_port} "
        "--response-size 512 >> /var/log/fraggle-amplifier.log 2>&1",
        fork=True,
    )
    host.appendClassName("SmurfAmplifierHost")
    host.appendClassName("FraggleAmplifierHost")


def customize_for_smurf_lab(
    emu: Emulator,
    hosts_per_as: int,
    amplifier_hosts: int,
    fraggle_port: int,
) -> None:
    add_amplifier_hosts(emu, amplifier_hosts=amplifier_hosts, hosts_per_as=hosts_per_as)

    configure_attacker(get_host(emu, *ATTACKER))
    configure_victim(get_host(emu, *VICTIM))
    configure_directed_broadcast_router(get_router(emu, AMPLIFIER_ASN, AMPLIFIER_ROUTER))

    amplifier_as = get_base(emu).getAutonomousSystem(AMPLIFIER_ASN)
    for index in range(amplifier_hosts):
        configure_amplifier_host(amplifier_as.getHost(f"host_{index}"), fraggle_port)


def build_smurf_emulator(hosts_per_as: int, amplifier_hosts: int, fraggle_port: int) -> Emulator:
    emu = Makers.makeEmulatorBaseWith5StubASAndHosts(hosts_per_as)
    customize_for_smurf_lab(
        emu,
        hosts_per_as=hosts_per_as,
        amplifier_hosts=amplifier_hosts,
        fraggle_port=fraggle_port,
    )
    return emu


def run(
    hosts_per_as=1,
    amplifier_hosts=12,
    fraggle_port=FRAGGLE_PORT,
    platform=Platform.AMD64,
) -> None:
    emu = build_smurf_emulator(
        hosts_per_as=hosts_per_as,
        amplifier_hosts=amplifier_hosts,
        fraggle_port=fraggle_port,
    )

    emu.render()

    docker = Docker(platform=platform)
    emu.compile(docker, str(SCRIPT_DIR / "output"), override=True)


def main() -> int:
    args = parse_args()
    run(
        hosts_per_as=args.hosts_per_as,
        amplifier_hosts=args.amplifier_hosts,
        fraggle_port=args.fraggle_port,
        platform=resolve_platform(args.platform),
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
