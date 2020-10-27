# TCP Attacks Lab

## For Ubuntu 20.04 

This lab requires three machines. We are going to use one VM, and then
run 2-3 containers inside the VM.
The lab description is updated to reflect the change on the setup. 

- When sniffing packets (using Scapy), we need to specify the interface name. 
In 16.04, the default interface is used, so we didn't have to specify
the interface. For the container setup, we have to specify it.

- For the RST and Session Hijacking attacks, there is no change 
caused by the OS.

- For the SYN flooding attack, there is a significant difference 
between Ubuntu 20.04 and 16.04. The issue is described 
in the lab description. 

- We removed the dependency on the ```netwox``` tool. For the RST
and session hijacking attacks, students will write their own 
tools using Scapy. For SYN flooding attacks, a C program is provided.


## Container Setup

- The lab uses the standard OneLAN setup. We need to add the following
to the Compose file, because inside the container, we won't be able to
turn off the SYN cookie countermeasure. We only need to do this for 
the victim machine. The Compose file will be provided on the lab's website.
  ```
    HostA:
        ...
        cap_add:
                - ALL
        sysctls:
                - net.ipv4.tcp_syncookies=0
        ...         
  ```

- For this lab, using the container setup is much more convenient
than using three VMs.


## Wish List

The RST attack on video streaming task is commented out, because 
it does not work any more, due to the improvement of the video streaming
software. In the future, I hope to use container to host our 
own streeming service, and then launch the RST attack on this server.

