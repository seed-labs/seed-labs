# Format String Lab

## For Ubuntu 20.04

For this lab, we keep the target vulnerable program 
at the 32-bit, because switching 
to the 64-bit makes the attack more difficult. We have
developed a new lab for the 64-bit programs. 
Here is the summary of the changes made to the lab description
and solutions:

- We added ```-m32``` to all the ```gcc``` command

- Issue: I was able to get the setuid version work (i.e., the target 
program is a setuid program), but for the server version, 
the attack fails. Still haven't figured out why. 
For 64-bit server version, the attack actually works. I will 
put this issue aside, and come back to solve it later. At 
least the 64-bit version works. 


