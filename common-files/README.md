# About this folder

This folder contains the header and copyright files
that are used by all the SEED labs. Changes made to
these files will affect all the SEED labs. This is 
by design, because we want all the SEED labs to
use the same copyright information and the same 
format.

This folder also contains the lab description contents
that are shared by multiple labs, such as 
the guidelines on containers and DNS setup. To 
avoid the duplication, we put the common contents
in this folder. Labs using these contents will simply
use `\input{file}` to include the files into their description. 
Dependency is also built into the `Makefile` of each lab,
so a change here will trigger the rebuilding 
of the lab description that depends on the changed files.


Because of its importance, changes to this 
folder can only be made by the maintainer of 
this repository. 
