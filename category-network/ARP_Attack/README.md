# ARP Attack Lab

## For Ubuntu 20.04 VM

The behavior on Ubuntu 20.04 VM is slightly different from that 
on Ubuntu 16.04. The code we used on 16.04 does not work, and
the problem is in the return packets. In the 16.04 code,
we simply forward the return packets. This does not have any problem in Ubuntu 16.04, but it
is not reliable on Ubuntu 20.04. I even tried on UDP, the problem is the same. Eventually, I decided to make
a copy of the return packet, and then send out the new packet. This is very reliable. I tried on both netcat
and telnet, as well as UDP, they all work very well. It seems to be the checksum issue. I need to remove
the checksum, so Scapy can re-calculate it. If I don’t do that, it won’t work.


After fixing this issue, the lab works for Ubuntu 20.04 VM with the container setting.

