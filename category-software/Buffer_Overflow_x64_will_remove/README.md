# Buffer Overflow Lab (64-bit)



## Update on 12/22/2020

This lab will no longer be used. It is replaced by the
`Buffer_Overflow_Server` and `Buffer_Overflow_Setuid` labs.


## Changes for the 64-bit Version 


When moving the Buffer Overflow Lab to Ubuntu 20.04,
we have decided to keep the 32-bit version lab as the basic 
lab, and then add this new lab as an advanced version,
because attacking 64-bit programs is indeed more 
challenging than attacking 32-bit programs.


The task description for the 64-bit lab is pretty much the same 
as the 32-bit version, so we will not duplicate that.
Students should still read the 32-bit version, but replace
the code and commands with the one described in this 
lab description.  

- The shellcode is replaced with the 64-bit shellcode
- We remove ```-m32``` from the compilation command
- We highlight a very unique challenge in the attack.
  The challenge is caused by zeros in the address. All addresses 
  in the 64-bit computers have two bytes of zeros, i.e., they
  all start with ```0x0000...```. We can't have zeros in 
  the payload, so how to solve this problem is the biggest 
  challenge we face in the 64-bit version. 

