# Lab Testing on ARM Platform

This document shows the progress of lab testing.
Brief notes can be placed in the table, but detailed
notes should be put inside the [Notes folder](./Notes).

Status symbols:
  - :white_check_mark: : Published on the SEED website
  - :thumbsup: : Ready, but not published yet
  - :construction_worker: : Work in progress
  - x:  Will not port (very difficult to port, or unnecessary)

## Software and Web Security

| Lab | Status | Notes |
| --- | --- | --- |
| Set-UID                   | :white_check_mark: | Fully tested |
| Buffer-Overflow (setuid)  | x  | Will not port. See [notes](Notes/Software_Security.md) |
| Buffer-Overflow (server)  | :white_check_mark:  | Added a new lab. See [notes](Notes/Software_Security.md) |
| Return-to-Libc  |  x   | Will not port. See [notes](Notes/Software_Security.md)|
| Format String   | :construction_worker:   | See [notes](Notes/Software_Security.md)|
| Shellcode       | :white_check_mark:   | Redesigned. See [notes](../../category-software/Shellcode/README.md) |
| Dirty Cow       |  x  | Will not port |
| Race Condition  | :white_check_mark: |  Fully tested      |
| CSRF            | :white_check_mark: | Tested the lab setup |
| XSS             | :white_check_mark: | Tested the lab setup |
| SQL Injection   | :white_check_mark: | Tested the lab setup |
| Shellshock      | :white_check_mark: | Tested the lab setup: [notes](Notes/Shellshock.md) |
| Clickjacking    | :white_check_mark: | tested the lab setup |

## Network Security

| Lab | Status | Notes |
| --- | --- | --- |
| Sniffing/Spoofing | :white_check_mark: | Fully tested; no issue |
| ARP               | :white_check_mark: | Fully tested; no issue |
| ICMP Redirect     | :white_check_mark: | Fully tested; [notes](Notes/Network_Security.md)|
| TCP               | :white_check_mark: | Fully tested; minor issue: [notes](Notes/Network_Security.md)|
| Mitnick           | :white_check_mark: | Fully tested; no issue |
| Firewall Exploration | :white_check_mark: | Fully tested; no issue: [notes](Notes/Network_Security.md) |
| Firewall Evasion  | :white_check_mark: | Full tested; no issue  |
| VPN Tunneling     | :white_check_mark: | Fully tested; no issue |
| Heartbleed        | x          | Will not port          |
| DNS Local         | :white_check_mark: | Fully tested; no issue |
| DNS Remote        | :white_check_mark: | Fully tested; no issue |
| DNS Rebinding     | :white_check_mark: | Fully tested; minor issues: [notes](Notes/Network_Security.md) |
| DNS Infrastructure| :white_check_mark: | Tested the emulator; no issue |
| DNSSEC            | :white_check_mark: | Tested the lab setup; no issue |
| BGP         | :white_check_mark: | Fully tested; minor issues: [notes](Notes/Network_Security.md) |
| Morris Worm | :white_check_mark: | See [notes](Notes/Network_Security.md) |

## Crypto Lab

| Lab | Status | Notes |
| --- | --- | --- |
| Secret-Key Encryption | :white_check_mark: | Fully tested; no issue |
| Padding Oracle | :white_check_mark: | Rebuilt the docker image; fully tested. See [notes](Notes/Crypto.md)|
| Hash Collision | :white_check_mark: | Fully tested; no issue: See [notes](Notes/Crypto.md) |
| Hash Length Extension | :white_check_mark: | Fully tested; no issue: See [notes](Notes/Crypto.md) |
| RSA Public Key | :white_check_mark: | Fully tested; no issue |
| PKI | :white_check_mark: | Fully tested; no issue |
| TLS | :white_check_mark: | Tested the client and server; no issue |
| Random Number | :construction_worker: | Lab needs to be modified. See [notes](Notes/Crypto.md) |


## Blockchain

| Lab | Status | Notes |
| --- | --- | --- |
| Blockchain Exploration | :white_check_mark: | Fully tested; no issue |
| Smart Contract Lab | :white_check_mark: | Fully tested; no issue |
| Blockchain: Reentrancy | :white_check_mark: | Fully tested; no issue |


## Others

| Lab | Status | Notes |
| --- | --- | --- |
| Meltdown | x | Will not port |
| Spectre  | x | Will not port |
