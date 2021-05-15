# Spectre Attack Lab


## Porting to Ubuntu 20.04 

This lab was originally developed on the 32-bit Ubuntu 16.04. When it was ported to
to the 64-bit Ubuntu 20.04, it did not work initially. However, after adding
`printf("something\n")` before calling `spectreAttack(larger_x)` (in both
`SpectreAttack.c` and `SpectreAttackImproved.c`), the Spectre attack became
successful. Not sure why. I guess this is a race condition problem, so the
timing matters. That extra `printf` statement might have got the timing correct.
On Ubuntu 16.04, there is no need for this extra printf statement. 


The attack works quite consistently on standalone SEED VM and cloud VM. 
