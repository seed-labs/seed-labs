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
