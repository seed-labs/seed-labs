# Building SEED VM for Apple Silicon Machines with VMware Fusion

As more and more people are using Apple machines with M1/M2/M3 chips (Apple Silicon), it becomes important to provide a virtual machine for students to conduct the SEED labs on their person computer (we used to ask them to do the labs the cloud). In this document, we are building 
a virtual machine for the Apple Silicon machine with VMware Fusion.  We document the choices, progress and the encountered issues.

## Building the SEED VM on Fusion

Step 1: Install VMware Fusion (which is free for personal use). A detailed instruction is provided in [SeedVM-Fusion_Installation.md](./seedvm-v2/SeedVM-Fusion_Installation.md).

Step 2: Build an Ubuntu VM on VMWare Fusion. 
Since the desktop versions of all Ubuntu VM are removed, we can no longer use the pre-built desktop versions. We install the server version instead, but don't worry about the GUI, as we will install ubuntu-desktop in the VM later. A detailed instruction is provided in [SeedVM-Ubuntu_Installation.md](./seedvm-v2/SeedVM-Ubuntu_Installation.md).

Step 3: Install software inside the VM to get the required environment of SEED labs. A detailed instruction is provided in [SeedVM-Lab_Setup.md](./seedvm-v2/SeedVM-Lab_Setup.md).
