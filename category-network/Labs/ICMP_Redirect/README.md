# IP/ICMP Attack Labs

## Update on January 9, 2021

The IP fragmentation task is removed, mostly because of two reasons:
First it depends too much on the implementation, the behaviors 
may become different when the OS kernel is updated. This makes
maintaining this tasks complicated. 
Second, the attacks do not work anymore in modern operating systems. 

Because of this change, the name of the lab is changed to 
"ICMP Redirect Attack", because the lab now only focuses 
on this attack. The old lab description is still kept 
in `Old_IP_Attacks.tex`.



## For Ubuntu 20.04

There is no issue porting this lab to Ubuntu 20.04. We have 
removed the reverse path filtering task, because by default, this is 
turned off, which is different from Ubuntu 16.04.

## Container Setup

There is no problem with Task 1, but when 
we launch the ICMP redirect attack against a container,
the attack does not succeed. If we do it against a VM,
there is no issue. We found out a potential reason, but
have not found way to resolve issue. We did find a way
to get around this issue. 

