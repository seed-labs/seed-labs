# SEED Manual for Containers

## Tutorials on Docker
- [A brief tutorial on Docker](./docker.md)
- [Commonly used commands](./docker-commands.md)
 

## Setting Up Lab Environment Using Docker Compose
- [Setting up A LAN Using Docker Compose](./compose-onelan.md) 
- [Setting up Two LANs Using Docker Compose](./compose-twolans.md) 
- [Building, Starting, and Stopping Containers](./compose-commands.md) 
- [Special Settings for Containers](./container-settings.md)
- [Running Commands inside Containers](./container-execute.md)
- [Detaching the VM From a Network](./detaching.md)

## Setting Up A DNS Infrastructure

In some labs, we need to include a DNS infrastructure,
which consists of a local DNS server,
an attacker's nameserver, and an user machine.
This section explains
how the DNS environment is set up. Students
can use this section as a reference to understand the setup.

- [Local DNS Server](./dns_local_dns_server.md) 
- [Attacker's Nameserver](./dns_attacker_ns.md)
- [User Machine](./dns_user_machine.md)
- [Testing the DNS Infrastructure](./dns_testing.md)

## Miscellanous Instructions

- Packet sniffing inside container
- Network interface name

## [Common Problems](./problems.md)