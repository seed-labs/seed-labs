# Software Security Labs

## Buffer Overflow Labs

We have designed a separate lab for arm64. The arm and amd versions
are still quite similar. In the amd version, L1 and L2 tasks
are based on the 32-bit code, while in the arm version,
all the tasks are based on the 64-bit code. However,
the tasks between these two versions are quite similar. 

We only ported the server version of the lab, as we
plan to gradually phase out the Set-UID version, so we 
can focus on one version (too time-consuming to maintain
two similar labs). Both labs can achieve the same educational 
objectives. 


## Return-to-libc Lab

Since this lab is based on the 32-bit x86 code, we will 
probably not port this lab to the ARM. We would like to develop
a new return-to-libc lab using the AMD64 code. When we 
start this project, we will also try the ARM64. Help is needed
to get this project started. 


## Format String Lab

Still under construction.

