#  How to Build SEED Ubuntu 20.04 VM from Scratch 

Building the SEED Ubuntu 20.04 VM involves the following steps:

1. [Create a VM](#1_-create-a-vm)
1. [Configure the VM](#2_-configure-the-vm)
1. [OS Installation and Configuration](#3_-os-installation-and-configuration)
1. [Installing Software Packages](#4_-installing-software-packages)
1. [Additional Manual Steps](#5_-additional-manual-steps)


## 1. Create a VM in VirtualBox

Install the free [VirtualBox](https://www.virtualbox.org/) software first.
Inside VirtualBox, we will create a VM instance. This involves
a series of steps: 

**Step 1: Name and operating system**. We will use the following 
parameters when creating the VM:
```
  Name: <pick a name>
  Machine folder: <you can use the default>  
  Type: Linux
  Version: Ubuntu (64-bit)
```

**Step 2: Memory size**. The minimal memory size is `2GB`. 
Pick more if your machine has enough memory.

**Step 3: Hard disk**. The configuration for the hard disk consists 
of several steps: 

- VirtualBox will ask you whether you want to create a new virtual disk
  or use an existing one; select `Create a virtual hard disk now`. 

- The hard disk file type we choose is `VDI` (Virtual Disk Image).

- Choose `Dynamically allocated` option for the storage on physical hard disk.

- Select `80 GB` for the virtual disk file size.


## 2. Configure the VM 

After the VM is created, go to its `Settings`. We will change 
some of the settings. Please go to the following setting categories:
`General`, `System`, `Display`, and `Network`, and change 
their parameters based on the following (a detailed manual on
changing the settings can be found in [this document](./seedvm-manual.md)).

```
  General 
     Advanced Tab:
        Shared Clipboard: Bidirectional
        Drag'nDrop: Bidirectional

  System:
     Motherboard Tab:
        Base Memory: 2GB
        Extended Feature:  Enable I/O APIC
     Processor Tab:
        Processors(s): 2 CPU
        Extended Features:
            Enable PAE/Nx
     Acceleration Tab:
        Hardware Virtualization:
            Enable VT-x/AMD-V
            Enable Nested Paging

  Display:
     Screen Tab:
        Video Memory: 28 MB
        Graphic Controller: VMSVGA
        Acceleration: Enable 3D Acceleration

  Network:
     Adapter 1:
        Attached to: NAT Network
        Advanced:
           Promiscuous Mode: Allow All
           MAC Address: (click generate new MAC)
```

**Note:** In the past, we had to use `VBoxVGA` for the display, otherwise,
the desktop won't go full screen. In the new VirtualBox version (6.1.10),
it seems that this graphic controller is causing trouble (system crash). 
We now switch to `VMSVGA` (the default). 
Online resources indicate that `VBoxVGA` is for legacy system,
`VBoxSVGA` is for Windows, while `VMSVGA` is for Linux. 


## 3. OS Installation and Configuration

Next, we install Ubuntu 20.04 OS in VirtualBox. We will 
not go to details on how to do that (you can find the 
instructions from online). We will only provide 
the important information that is needed during the 
installation.

**Step 1: OS installation**. 
When we install the Ubuntu 20.04 from the ISO file, 
we will be asked to provide additional information. 
Please use the following:

```
Update and Other software (take default):
    Normal Installation (default)
         web browsers, utilities, office,
    Download updates (default)

Installation Type (take default):
    Erase disk and install Ubuntu

Who are you
    Your name: SEED
    Your computer name: VM
    Pick a username: seed
    Password: dees (or pick a stronger one)
    Require my password to login
```

**Step 2: Install the Update**.
After the installation finishes, and we 
log into the seed account, the OS will prompt us to 
install the updates. Do it.

**Step 3: Install the Guest Addition**.
If we just go to the `Device` menu, click "Insert Guest Addition CD image",
it will not work, because it requires the kernel building tools, which
has not been installed yet. We can switch to the following step (these 
commands are already added to `guest-addition.sh`):

```
$ sudo add-apt-repository multiverse
$ sudo apt install virtualbox-guest-dkms virtualbox-guest-x11

// Rebooting the machine
$ lsmod | grep vbox
You will see the added kernel modules.
```

After rebooting the machine, the copy-and-paste will work. 


## 4. Installing Software Packages 

Most of the software package installation steps are automated with shell
scripts. We will install many software packages, and we group them
into individual shell scripts and they are stored in the  
[`lab-setup/ubuntu20.04-vm/src-vm`](https://github.com/seed-labs/seed-labs/tree/master/lab-setup/ubuntu20.04-vm/src-vm) 
folders of the SEED Labs GitHub repo. The main script is called `main.sh`, 
which will invoke all the other shell scripts in this folder. 

**Note:** This installation script will download and install all the software needed for
the SEED labs. The whole process will take a few minutes. Please
don't leave, because during the installation of Wireshark, you will be asked
whether non-superuser should be able to capture packets.
Select `No`.


## 5. Additional Manual Steps 

There are still a few steps that need to be done manually. They 
are described in [here](./vm-manual-steps.md).
