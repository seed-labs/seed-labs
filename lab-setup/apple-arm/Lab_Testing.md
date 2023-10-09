# Lab Testing on ARM Platform

This document shows the progress of lab testing. 
Brief notes can be placed in the table, but detailed
notes should be put inside the [Notes folder](./Notes).

## Software and Web Security 

| Lab | Status | Notes |
| --- | --- | --- |
| Set-UID                   | :thumbsup: | Fully tested |
| Buffer-Overflow (setuid)  | ---  | Lab needs to be changed to support arm64 architecture |
| Buffer-Overflow (server)  | ---  |  Lab needs to be changed to support arm64 architecture  |
| Return-to-Libc  |      | Lab needs to be revised for arm64 |
| Format String   |      | Lab needs to be revised for arm64 |
| Shellcode       |     |  Lab needs to be revised for arm64 |
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
| Sniffing/Spoofing | :thumbsup: | Fully tested: no issue |
| ARP               | :thumbsup: | Fully tested: no issue |
| ICMP Redirect     | | |
| TCP               | :thumbsup:  | Fully tested: [notes](Notes/Network_Security.md)|
| Mitnick           | | |
| Firewall Exploration | | |
| Firewall Evasion  | | |
| VPN Tunneling     | | |
| Heartbleed        | x | Will not port |
| DNS Local         | :thumbsup: | Fully tested: no issue |
| DNS Remote        | :question: | See [notes](Notes/Network_Security.md) |
| DNS Rebinding     | :thumbsup: | Fully tested; fixed issues: [notes](Notes/Network_Security.md) |
| DNS Infrastructure | | |
| DNSSEC | | |
| BGP | | |
| Morris Worm | | |

## Crypto Lab 

| Lab | Status | Notes |
| --- | --- | --- |
| Secret-Key Encryption | | The openssl library is compiled successfully |
| Padding Oracle | | |
| Hash Collision | | The program md5collgen is compiled successfully |
| Hash Length Extension | | |
| Random Number | | |
| RSA Public Key | | The program compiled successfully |
| PKI | | |
| TLS | | |


## Others

| Lab | Status | Notes |
| --- | --- | --- |
| Blockchain: Reentrancy | | | 
| Meltdown | x | Will not port | 
| Spectre  | x | Will not port | 
| | | | 
