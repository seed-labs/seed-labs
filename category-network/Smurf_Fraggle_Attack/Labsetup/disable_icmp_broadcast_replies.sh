#!/bin/bash

set -e

containers=$(docker ps --format '{{.Names}}' | grep '^as152h-' || true)

if [ -z "$containers" ]; then
    echo "No AS-152 host containers found."
    echo "Please start the emulator first, then run this script again."
    exit 1
fi

for container in $containers; do
    echo "Disabling ICMP broadcast replies on $container"
    docker exec "$container" sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
done

echo "Done."
