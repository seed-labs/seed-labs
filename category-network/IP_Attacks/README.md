# IP/ICMP Attack Labs


## For Ubuntu 20.04

There is no issue porting this lab to Ubuntu 20.04. We have 
removed the reverse path filtering task, because by default, this is 
turned off, which is different from Ubuntu 16.04.


## Container Setup

For Task 1 and Task 2, students can use two VMs or one VM + one container. 
There is no problem with Task 1 using the container approach, however, when 
we launch the ICMP redirect attack against a container (from a VM), 
the attack does not succeed. If we do it reversely, attacking a VM 
from a container, there is no issue. We have not figured out the reason
yet. For now, we will let students do Tasks 1 and 2 using VMs. 

