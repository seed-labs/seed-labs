# Install SEED VM on VirtualBox


## Preparation 

Before installing the SEED VM, please do the following:

- Install the free [VirtualBox](https://www.virtualbox.org/) software first. 
The VM has been tested on Version `6.1.16`.

- Download the zip file `SEED-Ubuntu20.04.zip` from the 
[SEED website](https://seedsecuritylabs.org/lab_env.html), unzip it, 
and you will get a `.vdi` file. This file contains the pre-built SEED 
Ubuntu 20.04 image. This document shows how to build a virtual machine
using this image. 


## Step 1: Create a New VM in VirtualBox

We need to use `New` to create a new virtual machine.

![New VM](./Figs/vm-new.png)

## Step 2: Provide a Name and Select the OS Type and Version

Our prebuilt Ubuntu 20.04 VM is 64-bit, so pick Ubuntu (64-bit). 

![name and OS type](./Figs/vm-name-type.png)


## Step 3: Set the Memory Size

We need to allocate dedicated memory for the VM. 
1024 MB should be sufficient, but we recommend 2GB. If your computer has more 
RAM, you can increase accordingly. The more memory you give to the VM, 
the better the performance you will get.

![memory](./Figs/vm-memory.png)

## Step 4: Select the Pre-built VM File Provided by Us

Click the folder image. On the popup window, use
the `Add` button to select the `.vdi` file downloaded 
from the SEED website.  

![choose vdi](./Figs/vm-hard-disk.png)

**Note**: If you get an error message saying that the UUID already exists,
this is because the UUID in the selected `vdi` file is the same as the 
one used by an existing VM. You can either remove the other VM or 
[change the UUID](https://tecadmin.net/change-the-uuid-of-virtual-disk/) 
in the `vdi` file.

## Step 5: Configure the VM

After the previous step, your VM will be created, and you will
see it on VirtualBox's VM panel. We need to do some further 
configuration. Right-click the M, click
the `Settings` option, and we will see the Settings window.

![finished](./Figs/vm-setting.png)


### Step 5.a: Enable Copy and Paste

Go to the `General` category, and select the `Advanced` tab. 
Select `Bidirectional` for both items. The first item allows users to copy
and paste between the VM and the host computer 
The second item allows users
to transfer files between the VM and the host computer using Drag'n Drop (this 
feature is not always reliable).

![general](./Figs/vm-setting-general.png)

The copy-and-paste feature is very useful. If you can't do copy and paste, 
chances are that you forgot to do this step. You can always do it later
by selecting the `Devices` menu item, and you will see the 
`Shared Clipboard` submenu. 


### Step 5.b: CPUs 

Go to the `System` category, and select the `Processor` tab. 
Assign number of CPUs to this VM if you prefer. Although may be sufficient,
if the performance seems to be an issue, increase the number. 

![CPU cores](./Figs/vm-setting-system.png)


### Step 5.c: Display

Go to the `Display` category, and select the `Processor` tab. If the 
display does not seem to work properly, try to increase the amount of video memory.
In our testing, `28 MB` seems to be sufficient. 

![display](./Figs/vm-setting-display.png)

**Note 1**: Make sure to select `VMSVGA`, as choosing other graphic controllers 
may lead to the crash of the VM.

**Note 2**: If your computer's screen resolution is too high, the VM may not be able 
to match the high resolution. As results, your VM will be very small on your screen. 
To make it bigger, adjust the `Scale Factor` in this setting. 

### Step 5.d: Network

Go to the `Network` category, and select the `Adapter 1` tab. We will
choose the `NAT Network` adaptor. Click the `Advanced` drop-down menu to
further configure the network adaptor.

![display](./Figs/vm-setting-network.png)


## Start the VM and Take Snapshot 

We can now start the VM. You can also use the `Take` button to take a snapshot 
of your VM. This way, if something goes wrong, you can roll back the state of
your VM using the saved snapshots. 

![display](./Figs/vm-start.png)

## Stop the VM

There are many ways to stop the VM. The best way is to use the `Save State`. This
is different from shutting down the VM. It saves the current VM state, so next time
when you restart the VM, the state will be recovered. Moreover, the speed is also
faster than booting up a VM.

![display](./Figs/vm-stop.png)


