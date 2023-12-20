# Lab Testing on ARM Platform

This document shows the progress of lab testing. 
Brief notes can be placed in the table, but detailed
notes should be put inside the [Notes folder](./Notes).

## Software and Web Security 

| Lab | Status | Notes |
| --- | --- | --- |
| Set-UID                   | :thumbsup: | Fully tested |
| Buffer-Overflow (setuid)  | x  | Will not port. See [notes](Notes/Software_Security.md) |
| Buffer-Overflow (server)  | :thumbsup:  | Added a new lab. See [notes](Notes/Software_Security.md) |
| Return-to-Libc  |  x   | Will not port. See [notes](Notes/Software_Security.md)|
| Format String   | :construction_worker:   | See [notes](Notes/Software_Security.md)|
| Shellcode       | :thumbsup:   | Redesigned. See [notes](../../category-software/Shellcode/README.md) |
| Dirty Cow       |  x  | Will not port |
| Race Condition  | :thumbsup: |  Fully tested      |
| CSRF            | :thumbsup: | Tested the lab setup |
| XSS             | :thumbsup: | Tested the lab setup |
| SQL Injection   | :thumbsup: | Tested the lab setup |
| Shellshock      | :thumbsup: | Tested the lab setup: [notes](Notes/Shellshock.md) |
| Clickjacking    | :thumbsup: | tested the lab setup |

## Network Security 

| Lab | Status | Notes |
| --- | --- | --- |
| Sniffing/Spoofing | :thumbsup: | Fully tested; no issue |
| ARP               | :thumbsup: | Fully tested; no issue |
| ICMP Redirect     | | |
| TCP               | :thumbsup: | Fully tested; minor issue: [notes](Notes/Network_Security.md)|
| Mitnick           | :thumbsup: | Fully tested; no issue |
| Firewall Exploration | :thumbsup: | Fully tested; no issue: [notes](Notes/Network_Security.md) |
| Firewall Evasion  | :thumbsup: | Full tested; no issue  |
| VPN Tunneling     | :thumbsup: | Fully tested; no issue |
| Heartbleed        | x          | Will not port          |
| DNS Local         | :thumbsup: | Fully tested; no issue |
| DNS Remote        | :question: | See [notes](Notes/Network_Security.md) |
| DNS Rebinding     | :thumbsup: | Fully tested; minor issues: [notes](Notes/Network_Security.md) |
| DNS Infrastructure | | |
| DNSSEC | | |
| BGP | :thumbsup: | Full tested; no issue |
| Morris Worm | :construction_worker: | See [notes](Notes/Network_Security.md) |

## Crypto Lab 

| Lab | Status | Notes |
| --- | --- | --- |
| Secret-Key Encryption | :thumbsup: | Fully tested; no issue |
| Padding Oracle | :question: | The docker image needs to be built |
| Hash Collision | :thumbsup: | Fully tested; no issue: See [notes](Notes/Crypto.md) |
| Hash Length Extension | :thumbsup: | Fully tested; no issue: See [notes](Notes/Crypto.md) |
| Random Number | :construction_worker: | Lab needs to be modified. See [notes](Notes/Crypto.md) |
| RSA Public Key | :thumbsup: | Fully tested; no issue |
| PKI | :thumbsup: | Fully tested; no issue |
| TLS | :thumbsup: | Tested the client and server; no issue |


## Blockchain

| Lab | Status | Notes |
| --- | --- | --- |
| Blockchain Exploration | :thumbsup: | Fully tested; no issue |
| Smart Contract Lab | :thumbsup: | Fully tested; no issue |
| Blockchain: Reentrancy | :construction_worker: | | 


## Others

| Lab | Status | Notes |
| --- | --- | --- |
| Meltdown | x | Will not port | 
| Spectre  | x | Will not port | 
