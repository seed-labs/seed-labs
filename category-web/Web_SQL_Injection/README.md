# SQL Injection Lab


## Porting to Ubuntu 20.04

This lab works on both Ubuntu 16.04 and 20.04 VM.
No change is needed when porting this 
lab to Ubuntu 20.04 VM. 

We did revise Task 4 (prepared statement). Instead of 
asking students to modify the actual web application, we 
create a simplified version, and ask students 
to modify this version. 


## For Container Setup

We have moved the web application setup to containers, and our Ubuntu 20.04 VM
will no longer host this web application. Since we only need
a browser on the VM, this lab can be done using
generic machines, no longer depending on our VM. Moreover, in the 
future, if we want to modify this web application, we can easily do
that in the container file, and there is no need to modify the VM any more. 
Having to modify the VM prevents us from doing frequent updates. 
