#!/usr/bin/env python3

import argparse
import os
import socket


def parse_args():
    parser = argparse.ArgumentParser(description="UDP responder for the Fraggle lab.")
    parser.add_argument("--port", type=int, default=7000)
    parser.add_argument("--response-size", type=int, default=512)
    return parser.parse_args()


def main():
    args = parse_args()
    if args.port < 1 or args.port > 65535:
        raise SystemExit("--port must be a valid UDP port")
    if args.response_size < 1 or args.response_size > 1400:
        raise SystemExit("--response-size must be between 1 and 1400")

    hostname = socket.gethostname().encode("utf-8", errors="replace")
    prefix = b"FRAGGLE-REPLY:" + hostname + b":"
    filler = b"X" * max(args.response_size - len(prefix), 0)
    response = (prefix + filler)[: args.response_size]

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(("0.0.0.0", args.port))

    print(f"fraggle amplifier pid={os.getpid()} listening on UDP/{args.port}", flush=True)
    while True:
        data, addr = sock.recvfrom(2048)
        print(f"received {len(data)} bytes from {addr[0]}:{addr[1]}", flush=True)
        sock.sendto(response, addr)


if __name__ == "__main__":
    main()
