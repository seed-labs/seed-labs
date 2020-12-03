# Lab Environment Setup for SEED Labs

This folder is for the developers of the SEED Labs and 
lab environment. It shows how to build the SEED Ubuntu 20.04 VM,
docker images used in the SEED Labs, and how to port the 
lab environment to various cloud platforms. 


## Folder Structure

The SEED labs can be deployed using a variety of platforms, including personal 
computer, cloud, and container. We would like to support them. Here is the 
structure of this folder:

- ```ubuntu20.04-vm```: Building the Ubuntu 20.04 VM for personal computer
- ```docker-images```: Docker images for the container setup
- ```aws```: For the AWS cloud platform
- ```cyber-range```: For the Virginia Cyber Range cloud platform


## Building the VM Image For SEED Labs

We are in the process of moving the SEED platform from Ubuntu 16.04 (32-bit)
to Ubuntu 20.04 (64-bit). 
Building a VM for SEED labs is one of the most challenging tasks in the 
SEED project. When we upgrade the platform, some SEED labs may be 
broken and need to fix. Most of the time, problems are small, and 
can be fixed quite quickly, but finding the problems is the most
time-consuming part. 

- Instruction and Scripts: Detailed building instructions can be found from the 
[README](ubuntu20.04-vm/README.md) file in the ```ubuntu20.04-vm/``` folder, which
also contains all the scripts we wrote for building the Ubuntu20.04 SEED VM.

- Beta Testing Period: Spring 2021. Here is the 
[VM image](https://seed.nyc3.cdn.digitaloceanspaces.com/SEEDUbuntu-20.04-v1.vdi.zip) for beta testing.

- Official Release Date: Summer 2021.

- Note: this image was built before the SEED labs are containerized (see below). 
After the containerization, this VM image will be revised, because many things
in this VM will no longer be needed (they are moved into containers). 

## Containerizing SEED Labs (SEED Labs 2.0)

In the past, SEED labs were conducted inside VMs. Some labs may need
several VMs, making the lab setup quite complicated. Using containers,
the setup can be much simpler. Moreover, with containers, the setup
for each lab is packaged into one single zip file, and the same 
setup can be recreated very easily in different platforms (physical 
machine, VM, or cloud). The setup will no longer be tied to 
a particular virtual machine. 

Switching from VM-based to container-based
platform led to significant changes to the design of many SEED labs, resulting 
in a new generation of SEED labs.  
Therefore, the new version will be officially called **SEED Labs 2.0**.

- Current status: work in progress, will finish by mid December
- Beta testing period: Spring 2021
- Official release date: Summer 2021. An online workshop will be organized to
help instructors adopt this new platform.  




## Help is needed for the following tasks

We plan to officially release the Ubuntu 20.04 in Summer 2021. Before that,
we need to fully test the VM to make sure it supports all the SEED labs,
and all the lab descriptions are revised accordingly. 

- **Mirror sites**: Once the VM is build, we need mirror sites to host the
image, so people in different regions of the world can easily download a copy
of the VM.

- **Create Cloud VM**: Once the VM is built, we need to customize it so
it runs efficiently on various cloud platform, such as AWS and Cyber Range. 
We also need to 
put the VM on cloud so others can directly run the VM from the cloud.
See the ```aws/``` folder for current work on an AWS build of the
SEEDUbuntu-16.04 VM.

- **Size reduction**: Right now, the size of the VM is quite large. 
If there is a better way to reduce the size of the VM, that will be great. 

- **Lab testing**: During the beta release phase, we need to test each lab
to identify whether there is any need to revise the lab description. For example,
we know that the buffer overflow lab and the format string lab need to modify,
because they use 32-bit shellcode, which does not run on the 64-bit machine.

