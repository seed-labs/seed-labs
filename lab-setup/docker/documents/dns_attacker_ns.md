# Configuring the Attacker Nameserver Container

To host a zone on the attacker container, we create
a zone file and copy it to the `/etc/bind` folder,
and then we add the following entries to
the `/etc/bind/named.conf` configuration file:

```
zone "attacker32.com" {
        type master;
        file "/etc/bind/zone_attacker32.com";
};
```

The zone file `zone_attacker32.com` is displayed
in the following. The actual ones in the lab setup may be
different from this one.

```
$TTL 3D
@       IN      SOA   ns.attacker32.com. admin.attacker32.com. (
                2008111001
                8H
                2H
                4W
                1D)

@       IN      NS    ns.attacker32.com.

@       IN      A     10.9.0.180
www     IN      A     10.9.0.180
ns      IN      A     10.9.0.153
*       IN      A     10.9.0.100
```

If any change is made to the zone file, please remember
to restart the nameserver or
run the following command to ask the nameserver
to reload the revised zone data.

```
# rndc reload attacker32.com
```
