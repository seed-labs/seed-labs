# Configuring the User Machine

In most DNS-related labs, we need to configure the User VM or container
to use the local DNS server in our setup. The ways to
configure a VM and a container is a little bit different.


## User Container

What local DNS server will be used is decided by the entries in
the resolver configuration file `/etc/resolv.conf`.
To use `10.9.0.53` as the local DNS server, we just
need to add the following to the file:

```
nameserver 10.9.0.53
```

## User VM

We can do the same thing for the user VM, but
there is a challenge: the provided SEED VM uses the
Dynamic Host Configuration Protocol (DHCP) to obtain network configuration parameters, such as IP address, local DNS server, etc. DHCP clients will 
overwrite the `/etc/resolv.conf` file with the information provided by the DHCP server.

One way to get our information into `/etc/resolv.conf` without worrying about
the DHCP is to add the following entry to the `/etc/resolvconf/resolv.conf.d/head`
file (`10.9.0.53` is the IP address of the local DNS server in our setup):

```
nameserver 10.9.0.53
```

The content of the head file will be prepended to the dynamically generated 
resolver configuration file. Normally, this is just a comment line (the comment in
`/etc/resolv.conf` comes from this head file). After making the change,
we need to run the following command for the change to take effect:

```
$ sudo resolvconf -u
```


