# Shellshock Lab  

The shellshock lab needs to use an old version of `bash`. The one included in 
the Lab setup file is not compatible with the `arm64` architecture. 
When we try to access the `vul.cgi` program on ```www.seedlab-shellshock.com/cgi-bin/vul.cgi```,
we get the internal server error. When we check the apache error log, we see the following error:

```[Sun Sep 03 22:49:01.046872 2023] [cgi:error] [pid 38] [client 10.9.0.1:41740] AH01215: (8)Exec format error: exec of '/usr/lib/cgi-bin/vul.cgi' failed: /usr/lib/cgi-bin/vul.cgi```

```[Sun Sep 03 22:49:01.047304 2023] [cgi:error] [pid 38] [client 10.9.0.1:41740] End of script output before headers: vul.cgi```

This error is caused because ```/bin/bash_shellshock``` is not compatible with the arm64 architecture. 
When we try to manually compile the `bash` program from the source, 
we get the following error:

```
$ wget https://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz
$ tar xzvf bash-4.2.tar.gz
$ cd bash-4.2
$ ./configure
checking build system type... ./support/config.guess: unable to guess system type

This script, last modified 2008-03-12, has failed to recognize
the operating system you are using. 
...
configure: error: cannot guess build type; you must specify one
```

And when we try to specify the build type, we get the following error:

```
$ ./configure --build=arm64
checking build system type... Invalid configuration `arm64': machine `arm64' not recognized
configure: error: /bin/sh ./support/config.sub arm64 failed
```

## Solution:

Instead of installing `bash-4.2`, we tried `bash-4.3`, which is also vulnerable 
to the Shellshock attack. 
  
``` 
wget https://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz
tar xzvf bash-4.3.tar.gz
cd bash-4.3
./configure
```

Change the following line in the Makefile and then run `make`:

```CC = gcc -static```

The added `-static` option is for static binding. This way,
when we put the binary in a container, it does not depend on
any dynamic linked library (which may be missing in a container). 
Static binding is a common solution to deal with the missing library issues. 


