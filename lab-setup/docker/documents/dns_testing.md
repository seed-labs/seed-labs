# DNS Testing

To check whether the DNS infrastructure is set up correctly or not, we can
run the following `dig` commands on the user VM and container.
The commands try to get the IP addresses of `www.attacker32.com`
and `ns.attacker32.com`. The addresses we
get should be the same as what is set in the
zone file (they should look like `10.9.0.x`); otherwise,
the lab environment is not set up correctly.


```
$ dig www.attacker32.com
...
;; ANSWER SECTION:
www.attacker32.com.     259200  IN      A       10.9.0.180

;; Query time: 4 msec
;; SERVER: 10.9.0.53#53(10.9.0.53)
...
```

Pay attention to the `SERVER` entry and verify that the response does come from 
your local DNS server `10.9.0.53`. If the response comes from a different IP 
address, either the setup on your user machine is not correct or the local
DNS server is not running. 