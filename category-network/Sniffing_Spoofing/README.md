# Packet Sniffing and Spoofing Lab

## For Ubuntu 20.04 

This lab requires two machines. We are going to use one VM, and then
run a container inside the VM for the second machine. 
The lab description is updated to reflect the change on the setup. 

- There is no change caused by the OS. The change described below
is mainly caused by the use of containers.

- When sniffing packets, we need to specify the interface name. 
In 16.04, the default interface is used, so we didn't have to specify
the interface. For the container setup, we have to specify it.


## Container Setup

- A new section on the container setup is added. Most of the content
are placed in common files, which will be shared by several labs.  

- The lab uses the standard OneLAN setup. No customization 
is needed. Even though the setup creates 3 containers, we only need
to use one of them.