
This folder stores the script to build a slim version
of the SEED Ubuntu 20.04 VM. Many labs are containerized,
so there is no need to install all the software packages
on the VM any more.

## VM Settings

When creating the VM, use the following settings.

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
        Graphic Controller: VBoxVGA
        Acceleration: Enable 3D Acceleration

  Network:
     Adapter 1:
        Attached to: NAT Network
        Advanced:
           Promiscuous Mode: Allow All
           MAC Address: (click generate new MAC)
```

## OS Settings

When installing the Ubuntu 20.04 OS, use the following settings.

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

The OS will prompt us to install the updates. Do it.


## Install the Guest Additions

Run `guest-addition.sh`. After this step, reboot the VM. 


## Intall Software Packages

Run `main.sh`, which will invoke other scripts.
