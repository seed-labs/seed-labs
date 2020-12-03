# SEED Manual for Containers

## Tutorials on Docker
- [A brief tutorial on Docker](./docker.md)
- [Commonly used commands](./docker-commands.md)
 

## Setting Up Lab Environment Using Docker Compose

In many of the SEED labs, we need several containers;
some labs may need more than 10 containers.
Creating them one by one and setting up their networks become tedious.
Docker provides a tool called Compose, which
simplifies the entire process. All the SEED labs will use
Compose to set up its container-based lab environments.

- [Using Docker Compose: Setting up a LAN](./compose-onelan.md) 
- [Setting up Multiple Networks](./compose-twolans.md) 
- [Building, Starting, and Stopping Containers](./compose-commands.md) 
- [Special Settings for Containers](./container-settings.md)


## Working with Containers

We provide manuals to help students who are not familiar with containers. 

- [Running Commands inside Containers](./container-execute.md)
- [Packet sniffing inside container](./container-sniffing.md)
- [Finding out network interface name](./container-interface.md)
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


## [Common Problems](./problems.md)