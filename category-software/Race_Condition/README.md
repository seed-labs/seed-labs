# Race Condition Lab

## For Ubuntu 20.04

Here is the summary of the changes made to the lab description
and solutions: 

- The code from the Ubuntu 16.04 version still works without any change. 

- We can now directly use ```renameat2``` in Ubuntu 20.04, instead of using 
  ```SYS_renameat2```. Although this is not a necessary change (without it,
  the code still works), it is good to use system calls in the standard way.
