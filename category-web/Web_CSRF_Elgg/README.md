# CSRF Lab


## Porting to Ubuntu 20.04

This lab works on both Ubuntu 16.04 and 20.04 VM.
We didn't change any existing attack tasks when porting this 
lab to Ubuntu 20.04 VM. 

For the countermeasure, we revised the secret token 
section, because the Elgg program has changed. We added 
a new task on samesite cookies. 


## For Container Setup

We have moved the Elgg setup to containers, and our Ubuntu 20.04 VM
will no longer host the Elgg website. Since we only need
a browser on the VM, this lab can be done using
generic machines, no longer depending on our VM.


