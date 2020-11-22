#  Building SEED Ubuntu 20.04 VM


Building the SEED Ubuntu VM involves the following steps:

1. [VM Configuration](#1_-vm-configuration)
1. [OS Installation and Configuration](#2_-os-installation-and-configuration)
1. [Installing Software Packages](#3_-installing-software-packages)
1. [Additional Manual Steps](#4_-additional-manual-steps)


## 1. VM Configuration

**Step 1: VM Creation**. We use the following 
parameters when creating the VM:
```
  Type: Linux
  Version: Ubuntu (64-bit)
  Hard disk file type: VDI, Dynamic Located
```

**Step 2: VM Settings**.
We use the following settings after creating the VM in 
VirtualBox:

```
  General:
     Shared Clipboard: Bidirectional
     Drag'nDrop: Bidirectional

  System:
     Motherboard:
        Base Memory: 1GB
        Extended Feature:  Enable I/O APIC
     Processor:
        Processors(s): 2 CPU
        Extended Features:
            Enable PAE/Nx
     Acceleration
        Hardware Virtualization:
            Enable VT-x/AMD-V
            Enable Nested Paging

  Display:
     Screen:
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
it seems that graphic controller is causing trouble (system crash). 
We now switch to `VMSVGA` (the default). 
Online resources indicate that `VBoxVGA` is for legacy system,
`VBoxSVGA` is for Windows, while `VMSVGA` is for Linux. 


## 2. OS Installation and Configuration

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
    Password: dees
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
$ sudo reboot
$ lsmod | grep vbox
You will see the added kernel modules.
```

After the above step, the guest addition is installed, 
but still the copy and paste does not work. We can go
to the `Device` menu, click "Insert Guest Addition CD image".
Since the kernel building tools have already been installed, 
this time, it will work, and after reboot, the copy and paste 
will also work.


## 3. Installing Software Packages 

Most of the software package installation steps are automated with shell
scripts. We will install many software packages, and we group them
into individual shell scripts and they are stored 
in the `src` and `src-slim` folders. The main script is called `main.sh`, 
which will invoke all the other shell scripts in this folder. 

During the installation, all the download files are put inside the 
`/home/seed/Downloads`, and the folder will be cleaned. 
Make sure you don't have anything valuable stored in there.

The `Files` folder contains configuration and customization
files for several software packages. For example,
Desktop customization files and Firefox customization
files are all stored in this folder. When we first 
build the VM, we did manual customization, and saved 
their files. This way, when we rebuild the VM, we 
do not need to go through those manual steps again. 

## 4. Additional Manual Steps 

There are still a few steps that need to be done manually. They 
are described in [manual_steps.md](./doc/manual_steps.md).
