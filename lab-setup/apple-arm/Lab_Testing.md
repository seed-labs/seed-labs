# Lab Testing on ARM Platform

This document shows the progress of lab testing. 
Brief notes can be placed in the table, but detailed
notes should be put in the `Notes_Lab_Testing.md` file. 

## Software and Web Security 

| Lab | Status | Notes |
| --- | --- | --- |
| Set-UID                   |                  |    |
| Buffer-Overflow (setuid)  |                  |    |
| Buffer-Overflow (server)  |                  |    |
| Return-to-Libc   |                  |             |
| Format String   |                  |             |
| Race Condition  |                  |             |
| Shellcode       |                  |                  |
| Dirty Cow       |  ---             | will not port    |
| CSRF | | |
| XSS | | |
| SQL Injection | | |
| Shellshock | | |
| Clickjacking | | |

## Network Security 

| Lab | Status | Notes |
| --- | --- | --- |
| Sniffing/Spoofing | | |
| ARP | | |
| ICMP Redirect | | |
| TCP | | |
| Mitnick | | |
| Firewall Exploration | | |
| Firewall Evasion | | |
| VPN Tunneling | | |
| Heartbleed | --- | will not port |
| DNS Local | | |
| DNS Remote | | |
| DNS Rebinding | | |
| DNS Infrastructure | | |
| DNSSEC | | |
| BGP | | |
| Morris Worm | | |

## Crypto Lab 

| Lab | Status | Notes |
| --- | --- | --- |
| Secret-Key Encryption | | |
| Padding Oracle | | |
| Hash Collision | | |
| Hash Length Extension | | |
| Random Number | | |
| RSA Public Key | | |
| PKI | | |
| TLS | | |


## Others

| Lab | Status | Notes |
| --- | --- | --- |
| Blockchain: Reentrancy | | | 
| Meltdown | | will not port | 
| Spectre  | | will not port | 
| | | | 
# Notes for Lab setup in Apple Silicon Machines


## Summary of the Suggestions




## Issue: 32-bit Libraries compilation



## Misc. Issues



## Testing Results: Labs with some issues

The follow labs have some issues. We document how they are 
resolved or what needs to be done to resolve them. 

- Software - Buffer Overflow Lab: not able to setup the /bof-container using make as arm does not support -m32 flag in gcc.
- Software - Return-to-libc Lab: not supported for arm archetecture.



## Testing Results: Labs without issues 

The following labs do not have issues in the VMware Fusion.

- Software - SetUID Lab: fully tested; no issue.
- Software - Race Condition lab: fully tested; no issue.
- Web - CSRF, XSS, and SQL Injection Labs: tested the lab setup environment. 
