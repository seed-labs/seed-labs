#!/bin/bash
chmod +x /interface_setup
/interface_setup

echo "ready! run 'docker exec -it $HOSTNAME /bin/bash' to attach to this node" >&2
for f in /proc/sys/net/ipv4/conf/*/rp_filter; do echo 0 > "$f"; done
cd /bof && ./server 

