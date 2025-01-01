# Ubuntu Installation for Apple Silicon Machines

- [Step 1: Download Ubuntu server version](#download)
- [Step 2: Install Ubuntu Desktop](#install)

## <a id="download"></a>Step 1: Download Ubuntu server version

Since the desktop versions of all Ubuntu VM are removed, we can no longer use the pre-built desktop versions but install the server version instead. We recommend downloading Ubuntu 22.04 version.

We will download the Ubuntu ISO image first. Go to [Ubuntu 22.04.5](https://cdimage.ubuntu.com/ubuntu/releases/22.04/release/) and download the Ubuntu 22.04.5 LTS (Jammy Jellyfish) . Make sure you download the `64-bit ARM (ARMv8/AArch64) server install image`.

![Ubuntu-ISO.png](./Figs/ubuntu-iso.png)

After the download is finished, start the VMware Fusion Player. Click on `Create a New Virtual Machine`.

In `Select the Installation Method`, select `Install from disc or image` and click on `Continue`.

![VMware Fusion Player Create New Virtual Machine](./Figs/vmware-fusion-player-create-new-virtual-machine.png)

Select the downloaded Ubuntu ISO image, and then click on `Continue`.

![VMware Fusion Player Select ISO](./Figs/vmware-fusion-player-select-iso.png)

In the next screen, make sure that 2 CPUs and 4 GB of RAM are selected. Click on `Finish`.

![VMware Fusion Player Finish](./Figs/vmware-fusion-player-finish.png)

The VM will be created and started. After the VM is started, click on `Try or install Ubuntu Server`.

![VMware Fusion Player Try Or Install Ubuntu Server](./Figs/vmware-fusion-player-try-or-install-ubuntu-server.png)

We will be greeted with the installation interface. Following the instructions below:

- Select the language as English.

	![Select Language](./Figs/select-language.png)
	

- For available installer update, select `Continue without updating`.

	![Continue Without Updating](./Figs/continue-without-updating.png)
	
- For Keyboard Configuration, select `Done` directly.

	![Keyboard Configuration](./Figs/keyboard-configuration.png)
	
- For Type of Installation, select `Ubuntu Server` and `Done`

	![Ubuntu Server](./Figs/ubuntu-server.png)
	
- For Network Configuration, select `Done` directly.

	![Network Configuration](./Figs/network-configuration.png)
	
-  For Proxy Configuration, select `Done` directly.

	![Proxy Configuration](./Figs/proxy-configuration.png)
	
- For Ubuntu Archive Mirror Configuration, wait until it complete the mirror location test and select `Done` directly.

	![Ubuntu Archive Mirror Configuration](./Figs/ubuntu-archive-mirror-configuration.png)
	
- For Guided Storage Configuration, select `Done` directly.

	![Guided Storage Configuration](./Figs/guided-storage-configuration.png)
	
- For Storage Configuration, select `Done` and `Continue` directly.

	![Storage Configuration](./Figs/storage-configuration.png)
	
- For Profile Configuration, create a user with name `seed` and select a password (you can use the standard password `dees` that we use for all SEED VMs). Then select `Done`.

	![Profile Configuration](./Figs/profile-configuration.png)
	
- For Upgrade to Ubuntu Pro, select `Continue` directly.

	![Upgrade to Ubuntu Pro](./Figs/upgrade-to-ubuntu-pro.png)
	
- For SSH Configuration, we recommend you to enable it, so select `Install OpenSSH server` and `Done`.

	![SSH Configuration](./Figs/ssh-configuration.png)
	
- For Featured Server Snaps, select `Done` directly.

	![Featured Server Snaps](./Figs/featured-server-snaps.png)
	
- Wait until it finish the installation and select `Reboot Now`

	![Reboot Now](./Figs/reboot-now.png)
	
- Maybe you will encounter the situation like `Failed unmounting /cdrom`, press enter directly.

	![Failed Unmounting](./Figs/failed-unmounting.png)
After the cloud-init operation, press enter and login your account:

![Login](./Figs/login.png)

***
## <a id="install"></a>Step 2: Install Ubuntu Desktop

In some of our labs, we are required to have a GUI to check the result. We will install ubuntu-desktop in the VM to get it. Use `sudo apt update` first and `sudo apt install ubuntu-desktop`

![Install Ubuntu Desktop](./Figs/install-ubuntu-desktop.png)

Wait until it finishes the installation. This may take long. Then `sudo reboot` and we will get the GUI we want!

![GUI](./Figs/GUI.png)