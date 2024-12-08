# Building SEED VM for Apple Silicon Machines with VMware Fusion

As more and more people are using Apple machines with M1/M2/M3 chips (Apple Silicon), it becomes important to provide a virtual machine for students to conduct the SEED labs on their person computer (we used to ask them to do the labs the cloud). In this project, we are building 
a virtual machine for the Apple Silicon machine with VMware Fusion.  We document the design choices, progress and the encountered issues in this project. 

## Building the SEED VM on Fusion

Step 1: Install VMware Fusion(which is free for personal use). A detailed instruction is provided in [SeedVM-Fusion_Installation.md](./SeedVM-Fusion_Installation.md).

Step 2: Build an Ubuntu VM on VMWare Fusion. 
Since the desktop versions of all Ubuntu VM are removed, we can no longer use the pre-built desktop versions but install the server version instead. But don't worry about the GUI. We will install ubuntu-desktop in the VM to get it. A detailed instruction is provided in [SeedVM-Ubuntu_Installation.md](./SeedVM-Ubuntu_Installation.md).

Step 3: Install software inside the VM to get the required environment of our labs. A detailed instruction is provided in [SeedVM-Lab_Setup.md](./SeedVM-Lab_Setup.md).