# Finding Out Network Interface Name

When we use the provided Compose file to create
containers for this lab, a new network is created
to connect the VM and the containers.
The IP prefix for this network is `10.9.0.0/24`,
which is specified in the `docker-compose.yml`
file. The IP address assigned to our VM is
`10.9.0.1`. We need to find the name of
the corresponding network interface on our VM, because we
need to use it in our programs.
The interface name is the concatenation of `br-`
and the ID of the network created by Docker.
When we use `ifconfig` to list network interfaces,
we will see quite a few. Look for the IP address
`10.9.0.1`.


``` shell
$ ifconfig
br-c93733e9f913: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.9.0.1 netmask 255.255.255.0  broadcast 10.9.0.255
        ...
```


Another way to get the interface name is to use the `"docker network"`
command to find out the network ID ourselves (the name of the network is
`seed-net`:

```
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
a82477ae4e6b        bridge              bridge              local
e99b370eb525        host                host                local
df62c6635eae        none                null                local
c93733e9f913        seed-net            bridge              local
```

