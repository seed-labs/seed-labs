# Buffer Overflow Lab (32-bit)

## Update on 12/22/2020

This lab will no longer be used. It is replaced by the
`Buffer_Overflow_Server` and `Buffer_Overflow_Setuid` labs. 


## For Ubuntu 20.04: Two Approaches

There are two choices we can take. 

- Change everything to 64-bit. This will be a significant change.

- Compile the vulnerable code to 32-bit binary. This approach
requires almost no change to the lab description. 

If we take the first approach, many instructors' teaching may be 
disrupted, because this will become a completely new lab. For the 
transition period, it is probably better to take the second approach.
In terms of buffer-overflow ideas, it really does not matter much.

Therefore, we decided to create two versions for the 
buffer-overflow attack, a 32-bit version and a 64-bit version. 
This folder is 
for 32-bit version. The 64-bit version is in 
a separate folder ([README](../Buffer_Overflow_x64/README.md)).


## The 32-bit Version 

There is not much change for porting the buffer-overflow lab to
Ubuntu 20.04 if we still compile the vulnerable program to 32-bin binary.
Here is the summary of the minor changes made to the lab description:

- We added ```-m32``` flag to the ```gcc``` command, indicating that we 
  want to generate 32-bit binary.

- The behavior of ```gdb``` is a little bit different. After stopping 
inside the ```bof``` function, the program stops at the point before
the ```ebp``` value changes. We do need to execute a statement 
inside the function to change the ```ebp``` value; otherwise we will
get the wrong value. 

- Everything else is pretty much the same: 
  - The shellcode is the same

  - The GDB investigation is the same

  - The brute-force attack against the address randomization 
    still works the same 

  - The way to defeat ```dash```'s countermeasure is also the same. 
