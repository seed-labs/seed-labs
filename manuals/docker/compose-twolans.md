# Setting Up Two LANS Using Compose

Another common setup used by SEED labs involves two LANs that
are connected by a router. The setup is depicted in the following
Figure. We will use Compose to build this lab environment.


![two LANs diagram](./Figs/TwoLANs.jpg)


## Creating Networks

In the `networks` section of the docker compose file,
we create two networks, and their IP prefixes are `10.9.0.0/24`
and `192.168.60.0/24`, respectively.

```
networks:
    net-10.9.0.0:
        name: net-10.9.0.0
        ipam:
            config:
                - subnet: 10.9.0.0/24

    net-192.168.60.0:
        name: net-192.168.60.0
        ipam:
            config:
                - subnet: 192.168.60.0/24
```

## Router

In the `services` section of the docker compose file, we
also create a router container, called  `Router`, which
connects to both networks. It
can route packets between these two networks.

```
services:
    Router:
        image: seed-ubuntu-base-image
        container_name: router-11
        tty: true
        sysctls:
                - net.ipv4.ip_forward=1
        networks:
            net-10.9.0.0:
                ipv4_address: 10.9.0.11
            net-192.168.60.0:
                ipv4_address: 192.168.60.11
        command: bash -c "
                      ip route del default  &&
                      ip route add default via 10.9.0.1 &&
                      /start.sh
                 "
```

In the configuration, we use the `sysctls` entry
to enable the IP forwarding inside the container;
otherwise, this container will not be able to route packets.
From the `networks` entry, we can see that
this container is attached to two networks, and thus
it has two IP addresses.

We added a `command` entry to all the all the containers. The command
will be executed once the container starts; it overrides the
`CMD` entry inside `Dockerfile`. We can only put one
single comment inside the `command` entry, so if we want to run
multiple commands, we can run a shell command and then ask the shell
to further execute our commands.

In this command, we set `10.9.0.1` as the
default router. It should be noted that the `10.9.0.1` is the
VM, i.e., the router use the VM as the default router
to reach the outside world.


Since the two `ip route` commands are not blocking, as
soon as they are finished, the container will exit.
we do not want that. To keep the container alive, we
need to run a blocking command at the end. For some containers,
this is achieved via running a server program, but for most
hosts, we simply fun `"tail -f /dev/null"` (included in
`start.sh`). Since there is no content `/dev/null`,
the `tail` command will block,
preventing the container from exiting.


## Host Containers

In the `services` section of the docker compose file, we
create four host containers. We put `HostA` on `10.9.0.0/24`
network, while putting `Host1`, `Host2`, and `Host3`
on `10.168.60.0/24` network.

```
services:
    HostA:
        ... (omitted) ...
        networks:
            net-10.9.0.0:
                ipv4_address: 10.9.0.5
        command: bash -c "
                      ip route add 192.168.60.0/24 via 10.9.0.11 &&
                      /start.sh
                 "

    Host1:
        ... (omitted) ...
        networks:
            net-192.168.60.0:
                ipv4_address: 192.168.60.5
        command: bash -c "
                      ip route del default  &&
                      ip route add default via 192.168.60.11  &&
                      /start.sh
                 "
```

In the command entries of these containers, we added
commands to set up the routing table. Hosts on
the two networks uses the router container to reach each other.

