# Local DNS Attack Lab

## For Ubuntu 20.04

The issues are similar to those in the Remote Attack Lab, so
we will not repeat it.


## Container Setup


Containers have significantly reduced the complexity of the lab setup. 
In the past, setting up the lab environment itself is a task that involves
several steps. Now, using containers, the entire lab environment can
be set up with a few commands.  

There is a very strange issue in this attack (using containers). 
The speed of sniffing-and-spoofing is too slow, even slower than
the authentic response from the Internet. That causes the problem
to the attack. I tried to use C code (instead of the Python code),
but the problems are the same. It seems that the virtual network
in Docker has caused the problem, but still haven't figured 
out why. 

To get around the issue, we use ```tc``` command to slow down the 
traffic going to the Internet. If we slow down 100 ms, the attack
will work.  The method is described in the lab description. 
I hope to be able to get rid of this work-around in the future. 



