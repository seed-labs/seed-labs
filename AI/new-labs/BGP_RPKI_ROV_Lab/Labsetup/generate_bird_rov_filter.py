#!/usr/bin/env python3
#
# Generate a simple BIRD Route Origin Validation filter from a CSV-like ROA
# table. This is an educational helper, not a replacement for a real RPKI
# validator and RTR session.

import ipaddress
import sys


def parse_roa_line(line):
    line = line.strip()
    if not line or line.startswith("#"):
        return None

    parts = [p.strip() for p in line.split(",")]
    if len(parts) < 3:
        raise ValueError(f"bad ROA line: {line}")

    prefix = ipaddress.ip_network(parts[0], strict=True)
    max_len = int(parts[1])
    origin_as = int(parts[2])
    description = parts[3] if len(parts) > 3 else ""

    if max_len < prefix.prefixlen or max_len > prefix.max_prefixlen:
        raise ValueError(f"bad maxLength in line: {line}")

    return prefix, max_len, origin_as, description


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} roa-table.txt", file=sys.stderr)
        return 1

    roas = []
    with open(sys.argv[1], encoding="utf-8") as f:
        for line in f:
            roa = parse_roa_line(line)
            if roa is not None:
                roas.append(roa)

    print("# BIRD educational ROV filter generated from ROA table")
    print("# Paste this function into /etc/bird/bird.conf and call it")
    print("# from the selected import filters.")
    print("function seed_rov_invalid()")
    print("{")
    print("    # A route is invalid if it is covered by a ROA, but")
    print("    # the origin AS or maxLength does not match that ROA.")

    for prefix, max_len, origin_as, description in roas:
        exact = f"{prefix.network_address}/{prefix.prefixlen}"
        allowed = f"{exact}{{{prefix.prefixlen},{max_len}}}"
        desc = f" # {description}" if description else ""
        print(f"    # ROA: {exact}, maxLength {max_len}, origin AS{origin_as}{desc}")
        print(f"    if net ~ [ {exact}{{{prefix.prefixlen},32}} ] then {{")
        print(f"        if !(net ~ [ {allowed} ]) then return true;")
        print(f"        if bgp_path.last != {origin_as} then return true;")
        print("    }")

    print("    return false;")
    print("}")
    print()
    print("# Example import-filter use:")
    print("# if seed_rov_invalid() then reject;")
    print("# accept;")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
