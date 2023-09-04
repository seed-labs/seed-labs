# Notes for Lab Testing

## Summary of the Suggestions


## Issue: 32-bit Libraries compilation gcc-multilib

Arm does not support the -m32 flag in gcc. This flag is required for the compilation of 32-bit libraries in the following labs:
- Software - Buffer Overflow Lab
- Software - Return-to-libc Lab

## Issue: /bin/bash_shellshock not compatible with arm64

In Shellshock lab, the apache-php-arm is created and the apache server is started. And we can also see the apache server running on ```www.seedlab-shellshock.com``` but when we try to access the vul.cgi file on ```www.seedlab-shellshock.com/cgi-bin/vul.cgi```, we get the internal server error. When we check the apache error log, we see the following error:

```[Sun Sep 03 22:49:01.046872 2023] [cgi:error] [pid 38] [client 10.9.0.1:41740] AH01215: (8)Exec format error: exec of '/usr/lib/cgi-bin/vul.cgi' failed: /usr/lib/cgi-bin/vul.cgi```

```[Sun Sep 03 22:49:01.047304 2023] [cgi:error] [pid 38] [client 10.9.0.1:41740] End of script output before headers: vul.cgi```

This error is caused because ```/bin/bash_shellshock``` is not compatible with arm64 architecture. So we will have to find a way to make it compatible with arm64 architecture.

## Misc. Issues
