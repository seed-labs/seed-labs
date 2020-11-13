# Setting Up Local DNS Server

For the local DNS server, we need to run a DNS server program.  The most
widely used DNS server software is called BIND (Berkeley Internet Name
Domain), which, as the name suggests, was originally designed at the
University of California Berkeley in the early 1980s.  The latest version
of BIND is BIND 9, which was first released in 2000. We will show how to
configure BIND 9 for our lab environment.

## 1. Configuration

BIND 9 gets its configuration from a file called `/etc/bind/named.conf`. This file
is the primary configuration file, and it usually contains several `include`
entries, i.e., the actual configurations are stored in those included files. One of the
included files is called `/etc/bind/named.conf.options`. This is where we typically set up
the configuration options. In the following, we describe the configuration.

### 1.1. Configure where to dump the DNS cache

The following option specifies where the cache content should be dumped to if
BIND is asked to dump its cache. If this option is not specified, BIND dumps
the cache to a default file called `/var/cache/bind/named_dump.db`.

```
options {
    dump-file "/var/cache/bind/dump.db";
};
```

The following two commands are related to DNS cache. The first command
dumps the content of the cache to the file specified above, and the second
command clears the cache.

```
# rndc dumpdb -cache    // Dump the cache to the specified file
# rndc flush            // Flush the DNS cache
```

### 1.2. Turn off DNSSEC

DNSSEC is introduced to protect against spoofing attacks on DNS servers.
To show how attacks work
without this protection mechanism, we need to turn the protection off.
This is done by modifying the `named.conf.options` file:
comment out the `dnssec-validation` entry, and
add a `dnssec-enable` entry.

```
options {
    # dnssec-validation auto;
    dnssec-enable no;
};
```

### 1.3. Fix the Source Ports

DNS servers now randomize
the source port number in their DNS queries; this makes the attacks much more
difficult. Unfortunately, many DNS servers still use predictable source
port number.  For the sake of simplicity in this lab, we assume that the
source port number is a fixed number. We can set the source port for all
DNS queries to `33333`. This can be done by adding the following option
to the file `/etc/bind/named.conf.options`:

```
query-source port 33333
```


### 1.4. Access Control

Access control

```
allow-query { any; };
allow-query-cache { any; };
allow-recursion { any; };
```


## 2. Set Up a Forward Zone

Many labs require us to host nameservers for some particular domain,
such as `attacker32.com`.
In the real world, the local DNS server needs to
find the IP address of this domain's nameserver.
It will go through the root server, the `com` server,
and eventually get a response from the actual
nameserver that hosts the `attacker32.com` domain.
Once the local DNS server gets the IP address, it will send
the query to this IP address. That is where students will have problems,
because students do not own this `attacker32.com` domain (it is
actually owned by Wenliang Du, the author of this lab), so students will not
be able to configure the DNS server running on `ns.attacker32.com`.


To solve this problem, each student can purchase his or her own domain, and then
use the purchased name in the attack, instead of using `attacker32.com`.
This way, students can configure their DNS
servers to answer queries. The cost of this approach is too high for students.

Fortunately, BIND9 allows us to add a forward zone in the DNS configuration.
Add the following zone entry to the `/etc/bind/named.conf` file.
This entry indicates that for all queries of the `attacker32.com`
domain, forward the queries to `10.9.0.153`.
This is equivalent to using `10.9.0.153` as the nameserver
for the `attacker32.com` domain. Therefore, with this entry,
the local DNS server will not try to find the IP address of
`attacker32.com`'s nameserver; it already has the IP address.
Please do not forget to include all those semicolons, or the
configuration will be invalid.


```
zone "attacker32.com" {
    type forward;
    forwarders {
        10.9.0.153;
    };
};
```



