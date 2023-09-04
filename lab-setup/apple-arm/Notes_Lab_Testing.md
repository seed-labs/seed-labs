# Notes for Lab Testing

## Summary of the Suggestions


## Issue: 32-bit Libraries compilation

As the architecture of the machine is arm64, there are different instruction set for arm64 and amd64.
So some of the labs which require to run on 32-bit amd64 architecture will not work on arm64 architecture
even if we compile the code with 32bit cross compiler. This will require the labs to be changed to support
arm64 architecture.

## Issue: /bin/bash_shellshock not compatible with arm64

In Shellshock lab, the apache-php-arm is created and the apache server is started.
And we can also see the apache server running on ```www.seedlab-shellshock.com``` but when
we try to access the vul.cgi file on ```www.seedlab-shellshock.com/cgi-bin/vul.cgi```,
 we get the internal server error. When we check the apache error log, we see the following error:

```[Sun Sep 03 22:49:01.046872 2023] [cgi:error] [pid 38] [client 10.9.0.1:41740] AH01215: (8)Exec format error: exec of '/usr/lib/cgi-bin/vul.cgi' failed: /usr/lib/cgi-bin/vul.cgi```

```[Sun Sep 03 22:49:01.047304 2023] [cgi:error] [pid 38] [client 10.9.0.1:41740] End of script output before headers: vul.cgi```

This error is caused because ```/bin/bash_shellshock``` is not compatible with arm64 architecture. 
So we will have to find a way to make it compatible with arm64 architecture.

When we try to manually compile the ```/bin/bash_shellshock``` manually, as the script is old
it is not compatible with the new version of bash. We will get the following error:

```
seed@seed-virtual-machine:~/Downloads/bash-4.2$ ./configure
checking build system type... ./support/config.guess: unable to guess system type

This script, last modified 2008-03-12, has failed to recognize
the operating system you are using. It is advised that you
download the most up to date version of the config scripts from

  http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD
and
  http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD

If the version you run (./support/config.guess) is already up to date, please
send the following data and any information you think might be
pertinent to <config-patches@gnu.org> in order to provide the needed
information to handle your system.

config.guess timestamp = 2008-03-12

uname -m = aarch64
uname -r = 6.2.0-32-generic
uname -s = Linux
uname -v = #32~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Fri Aug 18 12:38:40 UTC 2

/usr/bin/uname -p = aarch64
/bin/uname -X     =

hostinfo               =
/bin/universe          =
/usr/bin/arch -k       =
/bin/arch              = aarch64
/usr/bin/oslevel       =
/usr/convex/getsysinfo =

UNAME_MACHINE = aarch64
UNAME_RELEASE = 6.2.0-32-generic
UNAME_SYSTEM  = Linux
UNAME_VERSION = #32~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Fri Aug 18 12:38:40 UTC 2
configure: error: cannot guess build type; you must specify one
```

And when we try to specify the build type, we get the following error:

```
seed@seed-virtual-machine:~/Downloads/bash-4.2$ ./configure --build=arm64
checking build system type... Invalid configuration `arm64': machine `arm64' not recognized
configure: error: /bin/sh ./support/config.sub arm64 failed
```

## Misc. Issues
