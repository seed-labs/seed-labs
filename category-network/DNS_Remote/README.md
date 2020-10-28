# Remote DNS Attack Lab

## For Ubuntu 20.04

In Ubuntu 16.04, we have turned DNSSEC off using ```dnssec-enable no```.
that implies ```dnssec-validation no```. 
However, that does no seem to be true in Ubuntu 20.04. 
Without setting the latter to no, the attack does not work.
Once we made the following change, the attack works now.
Other than that, we did not encounter any problem during the VM upgrading.


## Container Setup

Containers have signficantly reduced the complexity of the lab setup. 
In the past, setting up the lab environment itself is a task that involves
several subtasks. Now, using containers, the entire lab environment can
be set up with a few commands.  

