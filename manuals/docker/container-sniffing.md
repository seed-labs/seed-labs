# Packet Sniffing in Container

Being able to sniffing packets is very
important for many labs, because if things do not go as expected, being
able to look at where packets go can help us identify the problems.
There are several different ways to do packet sniffing:

## Running `tcpdump` on containers.

We have already installed `tcpdump` on containers that need
sniffing. To sniff the packets going through a particular
interface, we just need to find out the interface name, and then do the
following (assume that the interface name is `eth0`):

``` shell
# tcpdump -i eth0 -n
```

It should be noted that inside containers, due to the isolation created by
Docker, when we run `tcpdump` inside a container,
we can only sniff the packets going in and out of this container.
We won't be able to sniff the packets between other containers.
However, if a container uses the `host` mode in its
network setup, it can sniff other containers' packets
(see [this manual](./container-settings.md)).


## Sniffing on the VM.

If we run `tcpdump`
on the VM, we do not have the restriction on the containers, and
we can sniff all the packets going among containers. The interface
name for a network is different on the VM than on the container.
On containers, each interface name usually starts with `eth`;
on the VM, the interface name for the network created
by Docker starts with `br-`, followed by the ID of the network.
You can always use the `ip address` command to get the
interface name on the VM and containers. See the instructions
on [how to find out network interface name](./container-interface.md).

We can also run Wireshark on the VM to sniff packets.
Similar to `tcpdump`, we need to select what interface
we want Wireshark to sniff on.

