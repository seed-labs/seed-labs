# Instructor Manual: Smurf and Fraggle Attack Lab

This manual is for instructors only. It contains one possible solution path,
expected observations, and helper scripts for completing the lab.

All commands below assume the SEED emulator is running and the user is working
inside the lab folder.

## Files In This Solution Folder

- `smurf.py`: Scapy solution for the Smurf attack.
- `fraggle.py`: Scapy solution for the Fraggle attack.
- `bcast-forward.sh`: Helper script to turn directed broadcast forwarding on or
  off on the AS-152 router.

The lab setup already provides `Labsetup/bcast-reply.sh`, which controls whether
AS-152 amplifier hosts reply to ICMP echo requests sent to the broadcast address.

## Preparation

Build and start the emulator:

```bash
cd Labsetup/output
docker-compose build
docker-compose up
```

In another terminal, identify the containers:

```bash
dockps | grep -i attacker
dockps | grep -i victim
dockps | grep -i as152
```

Expected roles:

- Attacker: AS-150, `10.150.0.71`
- Victim: AS-151, `10.151.0.71`
- Amplifier LAN: AS-152, `10.152.0.0/24`
- Directed broadcast address: `10.152.0.255`
- AS-152 router: `10.152.0.254`

Copy solution scripts to the attacker when needed:

```bash
docker cp Solution/smurf.py <attacker-id>:/root/smurf.py
docker cp Solution/fraggle.py <attacker-id>:/root/fraggle.py
```

Inside the attacker container:

```bash
chmod +x /root/smurf.py /root/fraggle.py
```

## Task 1: Inspecting The Lab Environment

Students should find the attacker, victim, AS-152 router, and AS-152 amplifier
hosts. Useful commands inside containers:

```bash
ip addr
ip route
```

On the victim, run:

```bash
tcpdump -n -i any icmp
```

From the attacker, run:

```bash
ping -c 3 10.151.0.71
ping -c 3 10.152.0.71
ping -c 3 10.152.0.255
```

Expected result:

- Ping to the victim should produce normal echo replies.
- Ping to one amplifier host should produce one reply per request.
- Ping to `10.152.0.255` should produce multiple replies, one from each
  responding amplifier host.

Explanation:

`10.152.0.255` is the directed broadcast address for `10.152.0.0/24`. Because
the AS-152 router forwards directed broadcasts, one ICMP echo request is
delivered to all hosts on the amplifier LAN. Each host replies to the source of
the request.

## Task 2: Writing The Smurf Attack Program

The important fields are:

- IP source: victim IP, `10.151.0.71`
- IP destination: AS-152 broadcast IP, `10.152.0.255`
- ICMP type: `8`, echo request

Instructor solution:

```bash
python3 /root/smurf.py --count 1
```

On the victim:

```bash
tcpdump -n -i any icmp
```

Expected result:

The victim receives ICMP echo replies from multiple AS-152 hosts, such as
`10.152.0.71`, `10.152.0.72`, and so on.

Explanation:

The attacker spoofs the source IP address as `10.151.0.71`. The amplifier hosts
believe the request came from the victim, so their echo replies are sent to the
victim instead of the attacker.

## Task 3: Measuring Smurf Amplification

On the victim:

```bash
tcpdump -n -i any 'icmp and src net 10.152.0.0/24'
```

From the attacker:

```bash
python3 /root/smurf.py --count 5 --interval 0.5
```

Expected result:

If there are `N` responding amplifier hosts and the attacker sends `C` spoofed
requests, the victim should receive approximately `N * C` ICMP echo replies.
With the default emulator, `--amplifier-hosts` is 12, so 5 requests should
produce about 60 replies.

Small differences may happen if packets are dropped, tcpdump starts late, or
students count packets after stopping the capture too early.

## Task 4: Writing The Fraggle Attack Program

On the victim:

```bash
nc -ul 7000
```

From the attacker:

```bash
python3 /root/fraggle.py --count 1
```

Expected result:

The victim prints UDP payloads beginning with `FRAGGLE-REPLY:`. The replies
come from the amplifier hosts.

Important packet fields:

- IP source: victim IP, `10.151.0.71`
- IP destination: broadcast IP, `10.152.0.255`
- UDP destination port: `7000`
- UDP source port: `7000`

Explanation:

The amplifier's UDP responder sends its response to the packet's source IP and
source UDP port. If the source port is not `7000`, the victim's `nc -ul 7000`
listener will not receive the replies.

To observe packets instead of payload text, the victim can run:

```bash
tcpdump -n -i any udp port 7000
```

## Task 5: Defense 1, Disabling Directed Broadcast

This defense should stop both Smurf and Fraggle because the router no longer
turns the packet sent to `10.152.0.255` into a LAN broadcast.

Use the helper script from the host:

```bash
chmod +x Solution/bcast-forward.sh
./Solution/bcast-forward.sh off
./Solution/bcast-forward.sh status
```

Alternatively, run these commands manually on the AS-152 router:

```bash
sysctl -w net.ipv4.conf.all.bc_forwarding=0
sysctl -w net.ipv4.conf.default.bc_forwarding=0
for f in /proc/sys/net/ipv4/conf/*/bc_forwarding; do echo 0 > $f; done
```

Run the attacks again:

```bash
python3 /root/smurf.py --count 1
python3 /root/fraggle.py --count 1
```

Expected result:

- Smurf should stop.
- Fraggle should stop.
- Victim should no longer receive reflected packets from multiple amplifier
  hosts.

Restore the original vulnerable setting when needed:

```bash
./Solution/bcast-forward.sh on
```

## Task 6: Defense 2, Disabling ICMP Broadcast Replies

This defense is host-side. It changes the amplifier hosts so they ignore ICMP
echo requests sent to a broadcast address.

From the host, run:

```bash
cd Labsetup
chmod +x bcast-reply.sh
./bcast-reply.sh off
./bcast-reply.sh status
```

Then run the attacks again from the attacker:

```bash
python3 /root/smurf.py --count 1
python3 /root/fraggle.py --count 1
```

Expected result:

- Smurf should stop, because the amplifier hosts ignore ICMP broadcast echo
  requests.
- Fraggle should still work, because this setting only affects ICMP broadcast
  echo requests. It does not disable the UDP responder.

Restore the original vulnerable setting:

```bash
./bcast-reply.sh on
```

## Answers To Main Conceptual Questions

Why do replies go to the victim?

The attacker spoofs the source IP address as the victim's address. Amplifier
hosts use the source IP address in the request as the destination IP address in
their replies.

Why does directed broadcast amplify traffic?

One packet sent to the directed broadcast address is delivered to many hosts on
the target LAN. If each host replies, one request creates many replies.

Why does the UDP source port matter in the Fraggle task?

The UDP responder replies to the source UDP port. The victim is listening on
UDP port 7000 using netcat, so the spoofed packet should also use source port
7000.

Which defense is more general?

Disabling directed broadcast forwarding is more general in this lab because it
prevents both ICMP-based and UDP-based reflection through the broadcast address.
Disabling ICMP broadcast replies only stops the Smurf attack.

## Cleanup

Stop the emulator:

```bash
cd Labsetup/output
docker-compose down
```

If the defense settings were changed during a live demonstration, restart the
emulator to return all containers to the original lab state.
