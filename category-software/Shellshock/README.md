# Shellshock Lab

## For Ubuntu 20.04

Here is the summary of the changes made to the lab description
and solutions:

- The code from the Ubuntu 16.04 version still works without any change.

- The reverse shell command has some issue. The ```nc -v -l 9090``` does not work; it produces
  an error message "```nc: getnameinfo: Temporary failure in name resolution```". 
  This is caused by the ```-v``` option, which tries to resolve the host name. We can simply
  add a ```-n``` option to ask ```nc``` not to do the name resolution. Therefore, the command
  becomes ```nc -nv -l 9090```. 


## For containers

The CGI server is now moved into the container. The lab does not depend on the VM
any more, so it can be conducted without using the SEED VM.
We placed binary version of vulnerable
bash in the container. If this causes an issue in the future, we can recompile 
the source code:

```
wget -P /tmp https://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz --no-check-certificate
cd /tmp
tar xzvf bash-4.2.tar.gz
cd bash-4.2
./configure
make

```
