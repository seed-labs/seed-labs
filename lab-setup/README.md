# Building the VM For SEED Labs

Building the VM for SEED labs is one of the most challenging tasks in the 
SEED project. When we upgrade the platform, some SEED labs may be 
broken and need to fix. Most of the time, problems are small, and 
can be fixed quite quickly, but finding the problems is the most
time-consuming part. 

We are in the process of moving the SEED platform from Ubuntu 16.04 (32-bit)
to Ubuntu 20.04 (64-bit). This is a significant upgrade, because we will 
switch to the 64-bit machine. We open source this VM building process,
so more people can benefit from it and can also contribute to the effort. 

## Instruction and Scripts

Detailed building instructions can be found from the 
[README](ubuntu20.04-vm/README.md) file in the ```ubuntu20.04-vm/``` folder, which
also contains all the scripts we wrote for building the Ubuntu20.04 SEED VM.

## Help is needed for the following tasks

We plan to officially release the Ubuntu 20.04 in Summer 2021. Before that,
we need to fully test the VM to make sure it supports all the SEED labs,
and all the lab descriptions are revised accordingly. 

- **Mirror sites**: Once the VM is build, we need mirror sites to host the
image, so people in different regions of the world can easily download a copy
of the VM.

- **Create Cloud VM**: Once the VM is built, we need to customize it so
it runs efficiently on various cloud platform, such as AWS. We also need to 
put the VM on cloud so others can directly run the VM from the cloud.
See the ```aws/``` folder for current work on an AWS build of the
SEEDUbuntu-16.04 VM.

- **Size reduction**: Right now, the size of the VM is quite large. 
If there is a better way to reduce the size of the VM, that will be great. 

- **Lab testing**: During the beta release phase, we need to test each lab
to identify whether there is any need to revise the lab description. For example,
we know that the buffer overflow lab and the format string lab need to modify,
because they use 32-bit shellcode, which does not run on the 64-bit machine.


## Beta Testing

We plan to use Spring 2021 for the Beta Testing of this VM. During
this phase, we hope to fix all the problems in the VM and lab
description.


## Official Release Date

We plan to officially release Ubuntu 20.04 VM, along with revised SEED labs in Summer 2021.

