# Detaching the VM from A Network

When Docker creates a network, it automatically attaches the
host machine (i.e., the VM) to the network. In some cases, we
created multiple networks, so the host machine will
be attached to both networks, and is given the IP address `.1`
for both networks. If we run the `ip route` command on the host
machine, we will see the following:

``` shell
$ ip route
10.9.0.0/24 dev br-56253b0deba4 proto kernel scope link src 10.9.0.1
192.168.60.0/24 dev br-19cdd4814e62 proto kernel scope link src 192.168.60.1
```

We can see that the host VM can directly access both networks.
This creates problems for some labs. In those labs, we want the
host VM to be attached to only one of the networks, not both.
We need to remove one direct access.
Assuming that we only want the VM to be connected to
`10.9.0.0/24`.
We need to detach the VM from the other network. We cannot simply power down
the interface, because that will affects all the containers on that network.
Our solution is to remove the IP address
of the interface, and then set the routing accordingly. The following
script does exactly that.

``` shell
$ sudo ip addr flush br-<nnn>
```

