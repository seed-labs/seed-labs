# Network Security

## Summary of Changes for Ubuntu 20.04

Detailed changes are described in the README file for each lab.
Here we only summarize how much change is made.
The Status column states whether the revision is finished or not.
The meaning of the Changes column can be found from
[this file](../common-files/category_of_revision.md).

| Lab Name | Changes | Status |  Notes |
| ---      | ---     | ---    |  ---   |
| Sniffing/Spoofing   | Minor | Done | [README](Sniffing_Spoofing/README.md)|
| ARP Cache Poisoning | Minor | Done | [README](ARP_Attack/README.md)|
| IP/ICMP             | Major | Done | [README](IP_Attacks/README.md)| 
| TCP Attacks         | Minor | Done | [README](TCP_Attacks/README.md)|
| Mitnick Attack      | Minor | Done | [README](Mitnick_Attack/README.md)| 
| Local DNS Attack    | Major | Done | [README](DNS_Local/README.md)|
| Remote DNS Attack   | Minor | Done | [README](DNS_Remote/README.md)|
| DNS Rebinding Attack| Minor | Done | [README](DNS_Rebinding/README.md)|
| DNS-in-a-box        |  New  | Done | [Designed for Ubuntu 20.04](DNS_in_a_Box/README.md) |
| Firewall Lab        | Major | Done | [README](Firewall/README.md)|
| VPN Tunneling       | Major | Done | [README](VPN_Tunnel/README.md) |
| VPN Lab             |  None | Done | [README](VPN/README.md)|
| BGP Lab             |  New  | Done | [Designed for Ubuntu 20.04](BGP_Basic/README.md)|
|||||
| DNSSEC              |  New  | Work in progress   | [Designed for Ubuntu 20.04](DNSSEC/README.md) |
| Firewall Evasion    |       | Work in progress   | [README](Firewall_VPN/README.md) |
| Heartbleed Attack   |       | Work in progress   | [README](Heartbleed/README.md) |
||||


## Notes Related to Containers

We will use the following rule when assigning docker images to containers and 
when configuring containers:
- A container should use the ```host``` mode if sniffing is needed
- A container should use the ```privileged``` mode if it needs to 
set kernel variables using ```sysctl```

