# Lab Environment Setup for Apple Silicon Machines


- [Step 1: Set Up the Host Apple Machine](#setup-host)
- [Step 2: Install VMWare Fusion Player](#install-fusion) 
- [Step 3: Create Ubuntu 22.04 VM on VMware Fusion Player](#create-vm)
- [Step 4: Install Software and Configure System](#install-software)


## <a id="setup-host"></a>Step 1: Set Up the Host Apple Machine

We need to install some software packages on the host Apple machine. 
To do that, we first need to install Homebrew, which
is a package manager for macOS (and Linux, too).
We assume that you already have docker 
install on your Apple machine. If you don't have it, 
please follow [these instructions](https://docs.docker.com/desktop/mac/install/).



### Step 1.1: Install Homebrew


To install Homebrew, open the terminal and run the following command.

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```

If you get this error: ```xcode-select: error:
invalid developer directory '/Library/Developer/CommandLineTools'``` during the installation,
this is because your `Xcode` is not installed or set up properly,
so ```/Library/Developer/CommandLineTools``` is not a valid directory for ```xcode-select```.

![xcode-select: error](Figs/xcode-select-error.png)

You can run the following command in the terminal to further confirm that
there is no active developer directory.

```xcode-select -p```

![error: no-active-directory](Figs/error-no-active-directory.png)

To solve the problem, you run the following command in the terminal to 
install `xcode-select`:

```xcode-select --install```

![xcode-select: install](Figs/xcode-select-install.png)

![xcode-select: install GUI](Figs/xcode-select-install-GUI.png)

If after installing homebrew you are not able to access brew, run the following command in the terminal.

```echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile```

```eval $(/opt/homebrew/bin/brew shellenv)```



## <a id="install-fusion"></a>Step 2: Install VMware Fusion Player

VMware Fusion Player is a free virtual machine software. 
It is similar to VirtualBox that we have been using 
for the SEED labs, but VirtualBox still cannot run 
reliably on Apple Silicon machines. 


Go to [VMware Fusion](https://customerconnect.vmware.com/en/evalcenter?p=fusion-player-personal-13) and either log in or register for a basic Broadcom account. 

![VMware Fusion Player](Figs/Broadcom_Homepage.png)

You will get this page when you registered successfully. You can skip `Build my Profile` for now.

![VMware Fusion Player](Figs/register_success.png)

Once logged in Broadcom account, we come back to [Broadcom Support Portal](https://support.broadcom.com/web/ecx/home) if we're not redirected there. We click the `Software` dropdown to choose the `VMware Cloud Foundation division` to select `My Downloads`.
![VMware Fusion Player](Figs/Broadcom_VMWare_cloud.png)

Find `VMware Fusion` in `My Downloads` page.

![VMware Fusion Player](Figs/vmware_fusion_download.png)

click `VMware Fusion 13 Pro for Personal Use` dropdown to choose `13.5.2` version.
![VMware Fusion Player](Figs/vmware_download_select_version.png)

In Primary Downloads page, find `.dmg` file and click download button to download the dmg file manually.
![VMware Fusion Player](Figs/vmware_download_web.png)

Installation is straight forward. Double click on the downloaded dmg file and follow the instructions.

![VMware Fusion Player](Figs/vmware_install.png)

After the installation is finished, you can start the VMware Fusion Player. 

You will be asked to enter license key. Select `VMware Fusion Pro for Personal Use`.

You will be asked to allow the kernel extensions. Click on `Open Security Preferences`.

In the Security & Privacy settings, click on `Allow` to allow the kernel extensions.



## <a id="create-vm"></a>Step 3: Create Ubuntu 22.04 VM on VMware Fusion Player

We are now ready to install the Ubuntu operating system.
We could not find the ARM version of Ubuntu 20.04, so we will install
Ubuntu 22.04 instead. 

We will download the Ubuntu ISO image first. 
Go to [Ubuntu 22.04.3](https://cdimage.ubuntu.com/jammy/daily-live/current/) and download the Ubuntu 22.04.3 LTS (Jammy Jellyfish) Daily Build. Make sure you download the `64-bit ARM (ARMv8/AArch64) desktop image`.

![Ubuntu ISO](Figs/ubuntu-iso.png)

After the download is finished, start the VMware Fusion Player. Click on `Create a New Virtual Machine`.

In `Select the Installation Method`, select `Install from disc or image` and click on `Continue`.

![VMware Fusion Player Create New Virtual Machine](Figs/vmware-fusion-player-create-new-virtual-machine.png)

Select `Use another disc or disc image...`, click on `Continue`, 
select the downloaded Ubuntu ISO image, and then click on `Open`.

![VMware Fusion Player Select ISO](Figs/vmware-fusion-player-select-iso.png)

Now click on `Continue`. In the next screen, make sure that 2 CPUs and 4 GB of RAM are selected. Click on `Finish`.

![VMware Fusion Player Finish](Figs/vmware-fusion-player-finish.png)

The VM will be created and started. After the VM is started, click on `Try or insall Ubuntu`.

![VMware Fusion Player Try or Install Ubuntu](Figs/vmware-fusion-player-try-or-install-ubuntu.png)

We will be greeted with the Ubuntu home screen. 
Since we need a permanent installation for our labs, 
we will click on the `Install Ubuntu` icon.

![Ubuntu Home Screen](Figs/ubuntu-home-screen.png)

During the installation, select `Minimal Installation` and click on `Continue`.

![Ubuntu Installation](Figs/ubuntu-installation.png)

In the next screen, select `Erase disk and install Ubuntu` and click on `Install Now`.

![Ubuntu Installation](Figs/ubuntu-installation-erase.png)

Create a user with name `seed` and select a password (you can
use the standard password `dees` that we use for all SEED VMs).
Click on `Continue`.

![Ubuntu Installation](Figs/ubuntu-installation-user.png)

The installation will start. After the installation is finished, click on `Restart Now`.

If this gives you an error, just remove the ISO image from the VM and restart
the VM. To do that, go to `Virtual Machine` -> `Settings` -> `CD/DVD (SATA)` and
uncheck `Connect CD/DVD Drive`. Click on `Apply` and `OK`. Now restart the VM.

![Ubuntu Installation](Figs/ubuntu-installation-cd.png)

Now you will be greeted with the home screen.


### Setup Bidirectional Shared Clipboard

In the default setting, the copy-and-paste does not work between your host
Apple machine and the VM running inside VMware Fusion. This is quite inconvenient. 
You can install ```vmware tools``` to set up a bidirectional shared clipboard.
Run the following commands.

```
sudo apt-get upgrade
sudo apt-get install open-vm-tools-desktop -y
sudo reboot
```

## <a id="install-software"></a>Step 4: Install Software and Configure System

We are now ready to install all the software packages needed for 
the SEED labs. 

Go to terminal, first download `curl` using

```
sudo apt-get install curl
```

Download [`src-arm.zip`](https://seedsecuritylabs.org/setup/src-arm.zip)
from the link or using the following `curl` command.

  ```
  curl -o src-arm.zip https://seedsecuritylabs.org/setup/src-arm.zip
  ```

In order to unzip the file, we first need to install the `unzip` program
  using the following command. After that, unzip the file.
  ```
  sudo apt update
  sudo apt -y install unzip
  unzip src-arm.zip
  ```

After unzipping the file, you will see a `src-arm` folder.
  Enter this folder, and run the following command to install software
  and configure the system.
  ```
  ./install.sh
  ```

- **Note:** This shell script will download and install all the software needed for
  the SEED labs. The whole process will take a few minutes. Please
  don't leave, because you will be asked twice to make choices:

  - During the installation of Wireshark, you will be asked
    whether non-superuser should be able to capture packets.
    Select `No`.

  - During the installation of `xfce4`, you will be asked to
    choose a default display manager. Choose `LightDM`.


After the script finishes, we can switch to the `seed`
account using the following command:
```
sudo su seed
```

