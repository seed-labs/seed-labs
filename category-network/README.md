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
| Firewall Lab        | Major | Done | [README](Firewall/README.md)|
| VPN Tunneling       | Major | Done | [README](VPN_Tunnel/README.md) |
| DNS-in-a-box        |  New  | Done   | Designed for Ubuntu 20.04 |
| DNSSEC              |  New  | Done   | Designed for Ubuntu 20.04 |
|||||
| Firewall Evasion    |  --   | --   | [README](Firewall_VPN/README.md) |
| VPN Lab             |  --   | --   | [README](VPN/README.md)|
| Heartbleed Attack   |  --   | --   | Work in progress       |
||||



## Network Topology and Docker Images Used

We will use the following rule when assigning docker images to containers and 
when configuring containers:
- Attacker Container: Use the Scapy image, unless it doesn't use Python
- Victim Container: Use the Ubuntu 20.04 image
- User/Observer Container: Use the Ubuntu 20.04 image.
- A container should use the ```host``` mode if sniffing is needed
- A container should use the ```privileged``` mode if it needs to 
set kernel variables using ```sysctl```

| Lab Name | Topology |  Ubuntu | Scapy | Flask  |
| ---      | :---:  | :---: | :---:  | :---: |
| Sniffing/Spoofing   | 1 LAN  | x | x |   |
| ARP Cache Poisoning | 1 LAN  | x | x |   |
| IP/ICMP             | 2 LANs | x | x |   |
| TCP Attacks         | 1 LAN  | x | x |   |
| Mitnick Attack      | 1 LAN  | x | x |   |
| Local DNS Attack    | 2 LANS | x | x |   |
| Remote DNS Attack   | 1 LAN  | x | x |   |
| DNS Rebinding Attack| 2 LANs | x |   | x |
| Firewall Lab        | 2 LANs | x |   |   |
| VPN Tunneling       | 2 LANs |   | x |   |
| DNS-in-a-box        | 1 LAN  | x |   |   |
| DNSSEC              | 1 LAN  | x |   |   | 
|||||
| Firewall Evasion    | No need | | | |
| VPN Lab             | No need | | | |
| Heartbleed Attack   | | | | |
