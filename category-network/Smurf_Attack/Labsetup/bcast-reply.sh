#!/bin/bash

set -e

usage() {
    echo "Usage: $0 {on|off|status}"
    echo
    echo "  on      enable ICMP replies to broadcast echo requests"
    echo "  off     disable ICMP replies to broadcast echo requests"
    echo "  status  show the current setting on each AS-152 host"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

case "$1" in
    on)
        value=0
        action="Enabling"
        ;;
    off)
        value=1
        action="Disabling"
        ;;
    status)
        value=""
        action="Checking"
        ;;
    *)
        usage
        exit 1
        ;;
esac

containers=$(docker ps --format '{{.Names}}' | grep '^as152h-' || true)

if [ -z "$containers" ]; then
    echo "No AS-152 host containers found."
    echo "Please start the emulator first, then run this script again."
    exit 1
fi

for container in $containers; do
    if [ "$1" = "status" ]; then
        current=$(docker exec "$container" cat /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts)
        echo "$container: net.ipv4.icmp_echo_ignore_broadcasts=$current"
    else
        echo "$action ICMP broadcast replies on $container"
        docker exec "$container" sysctl -w net.ipv4.icmp_echo_ignore_broadcasts="$value"
    fi
done

echo "Done."
