# Shellcode Lab

## Update on December 2023

We made a significant change to this lab. Here is the summary of the 
changes:

- Shellcode for arm64 is now supported, so students with Apple silicon
  machines can also work on this lab.

- Since arm64 does not support the 32-bit code, we decided to remove
  the 32-bit code for amd64 as well, so the lab is consistent for 
  both architectures. 

- We also switch the focus: the previous focus was on the stack approach,
  the new version is on the PC approach, as this approach is easier to 
  write and more generic. 


## For Ubuntu 20.04 (update on May 2020)

Here is the summary of the changes made to the lab description
and solutions:

- Since 64-bit CPU can still run 32-bit code, all the 32-bit shellcode
  still works. The only thing we need to change is the linker command. 
  To link the 32-bit code, we need to add the "```-m elf_i386 ```" option 
  in the ```ld``` linker command. 

- Tasks 1 and 2 are still writing 32-bit shellcode. We added a new task, Task 3, 
  which focuses on writing 64-bit shellcode.

