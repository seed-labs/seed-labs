# Mitnick Attack Lab

## For Ubuntu 20.04 


- We did not encounter any problem during the VM upgrading.


## Container Setup

- There is no problem switching to the container setup (just make
sure set the interface when calling ```sniff```). The attacker
container needs to be in the `host` mode, otherwise, it won't be
able to sniff other container's packets.

- The old ```rsh``` programs are installed inside the container. 

- We already created a "seed" account inside the container. When
we are in the container, we shoud "su seed" to get into the seed
account. 
