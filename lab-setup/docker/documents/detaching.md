# Detaching the VM from A Network

As we mentioned before, when Docker
creates a network, it automatically attaches the
host machine (i.e., the VM) to the network. In this
case, the host machine is attached to both
networks, and is given the IP address `10.9.0.1` and
`192.168.60.1`. If we run the `ip route` command,
we will see the following:

```
$ ip route
10.9.0.0/24 dev br-56253b0deba4 proto kernel scope link src 10.9.0.1
192.168.60.0/24 dev br-19cdd4814e62 proto kernel scope link src 192.168.60.1
```

We can see that the user VM can directly access the `192.168.60.0/24` network.
That is different from what is depicted in Figure.
We want to remove this direct access, but if we shutdown this link,
the containers will be affected (containers rely on this link).

To simulate the setup, we need to detach the VM from
the `192.168.60.0/24` network. We cannot remove the
the interface (that will affect many containers). We simply
remove the VM's IP address from this interface, so
the interface cannot be used. The following
shell script will achieve that.

