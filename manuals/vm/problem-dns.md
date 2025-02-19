# Common DNS Problems


## Problem 1: No Internet Connection due to DNS 

**Problem Description:** After installing the Ubuntu 20.04 VM, some students
do not seem to have Internet connection. After some investigation, it seems
that the machine can actually ping outside using IP addresses, but not hostnames.
Therefore, the problem is on the DNS server. 

**Investigation:** 
The VM uses `127.0.0.53` as its DNS server, but this 
is just the `systemd-resolved` stub resolver, not the actual DNS server. 
We run the following command to see what actual DNS server is used. 

```
$ systemd-resolve --status
...
Link 2 (enp0s3)
      Current Scopes: DNS
      ...
  Current DNS Server: 10.0.2.3
         DNS Servers: 10.0.2.3
```

Therefore, the actual DNS server is `10.0.2.3`, which is a server provided by 
VirtualBox; it does not run inside the VM.
We directly use this server to do DNS query, but could not get response
from this server (pinging is fine). 

```
$ dig @10.0.2.3 www.example.com
```

We still could not figure out what the problem is. It could be Windows firewall issues, or some
other issues. 


**A walk-around solution:** 
We can use the following method to walk around this issue (before we figure out the actual
problem). The idea is to ask our system not to use `127.0.0.53` as the DNS server; instead,
we will use `8.8.8.8`, a DNS server provided by Google. 

To achieve this, we need to add an entry to  `/etc/resolv.conf`, but
the content of this file will be overwritten by DHCP. 
One way to get our information into `/etc/resolv.conf` without worrying about the DHCP is to
add the following entry to the `/etc/resolvconf/resolv.conf.d/head` file. 
The content of the head file will be prepended to the dynamically generated
resolver configuration file.  

```
nameserver 8.8.8.8
```

After making the change, we need to run the following command for the change to take effect:

```
$ sudo resolvconf -u
```

This should solve the DNS problem. 



