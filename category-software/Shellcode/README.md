# Shellcode Lab

## For Ubuntu 20.04

Here is the summary of the changes made to the lab description
and solutions:

- Since 64-bit CPU can still run 32-bit code, all the 32-bit shellcode
  still works. The only thing we need to change is the linker command. 
  To link the 32-bit code, we need to add the "```-m elf_i386 ```" option 
  in the ```ld``` linker command. 

- Tasks 1 and 2 are still writing 32-bit shellcode. We added a new task, Task 3, 
  which focuses on writing 64-bit shellcode.

