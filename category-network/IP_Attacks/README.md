# IP/ICMP Attack Labs


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

