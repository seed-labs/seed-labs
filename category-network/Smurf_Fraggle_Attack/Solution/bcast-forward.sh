#!/bin/bash

set -e

usage() {
    echo "Usage: $0 {on|off|status}"
    echo
    echo "  on      enable directed broadcast forwarding on the AS-152 router"
    echo "  off     disable directed broadcast forwarding on the AS-152 router"
    echo "  status  show current bc_forwarding settings on the AS-152 router"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

router=$(docker ps --format '{{.Names}}' | grep '^as152r-router0-' | head -n 1 || true)

if [ -z "$router" ]; then
    echo "AS-152 router container not found."
    echo "Please start the emulator first, then run this script again."
    exit 1
fi

case "$1" in
    on)
        value=1
        ;;
    off)
        value=0
        ;;
    status)
        docker exec "$router" sh -c \
            'for f in /proc/sys/net/ipv4/conf/*/bc_forwarding; do echo "$f=$(cat "$f")"; done'
        exit 0
        ;;
    *)
        usage
        exit 1
        ;;
esac

echo "Setting directed broadcast forwarding to $value on $router"
docker exec "$router" sh -c "sysctl -w net.ipv4.conf.all.bc_forwarding=$value || true"
docker exec "$router" sh -c "sysctl -w net.ipv4.conf.default.bc_forwarding=$value || true"
docker exec "$router" sh -c \
    "for f in /proc/sys/net/ipv4/conf/*/bc_forwarding; do [ -e \"\$f\" ] && echo $value > \"\$f\"; done"

echo "Done."
