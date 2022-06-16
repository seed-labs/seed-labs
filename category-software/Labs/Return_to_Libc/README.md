# Return-to-Libc Lab


## Lab revision update on 12/28/2020

The lab was partitially re-designed. We use a different way to defeat the 
countermeasures in `bash` or `dash` (Task 4). This method is much simpler than
the ROP method. We also added an optional task (Task 5) to give students
a taste of ROP (a special case of ROP). Generic ROP is quite complicated, 
and we plan to develop a separate lab on ROP in the future.


## Design Decision 

Doing the return-to-libc attack on x64 machines is much more difficult
than doing it on x86 machines. The reasons are described below:

- In the basic return-to-libc attack, we return to the ```system()```
  function. We pass the address of the command string ```/bin/sh``` 
  to ```system()``` using the stack. 
  In the x64 architecture, the first six arguments are no
  longer passed using the stack; they use registers. 
  Therefore, the basic scheme does not work anymore.

- The attack still works, it just becomes much
more complicated. To invoke ```system("/bin/sh")```, we
need to store the address of the shell string in the rdi register. 
We have to use the gadget approach, i.e.,
finding the existing code that contains pop rdi before executing 
ret (having some code in between is fine). This is quite challenging
for labs. 

- Another challenge is that all the addresses now contains at least 
two null bytes. There are ways to solve this problem, 
but the solution becomes very complicated. Basically, 
we need to use the return-oriented programming (ROP)
to solve this problem.

Due to its difficulty described above, to keep the lab 
simple, we decide to still use the 32-bit program  
as our target program, instead of switching to 64-bit. 

## Changes for Ubuntu 20.04

Because of our design decision, no significant change is 
needed when porting this lab to Ubuntu 20.04. 
Here is the summary of the changes made to the lab description:

 - Add the ```-m32``` flag to all the ```gcc``` commands

 - Added a note regarding the x86 and x64 architectures.

