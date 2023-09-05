# Lab Setup for Apple Silicon Machines

## Local Setup for Apple Silicon Machines [For Web Security Labs]

Note: This method is only tested for the web security labs.

For this we are assuming that you have docker setup in your machine. If you don't have docker setup in your machine, please follow the instructions from [here](https://docs.docker.com/desktop/mac/install/).

### Step 1: Install Homebrew
To install Homebrew, open the terminal and run the following command.

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```

If after installing you are not able to access brew, run the following command in the terminal.

```echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile```

```eval $(/opt/homebrew/bin/brew shellenv)```

### Step 2: Install docker-mac-net-connect
This is required to connect the docker container to the host network. To install docker-mac-net-connect, open the terminal and run the following command.

```brew install chipmk/tap/docker-mac-net-connect```

And then start the service using the following command.

```sudo brew services start chipmk/tap/docker-mac-net-connect```

Now if you run the Labsetup for arm version you will be able to perform the web security labs.

## VMware Fusion Player Setup for Apple Silicon Machines

### Step 1: Install VMware Fusion Player on Apple Silicon Machines

Go to [VMware Fusion](https://customerconnect.vmware.com/en/evalcenter?p=fusion-player-personal-13) and register for a free Fusion Player license. Then under License & Download, click on `Manually Download`.

![VMware Fusion Player](Figs/vmware-fusion-player-web.png)

Installation is straight forward. Download the dmg file manually from the link provided in the installation page. Double click on the dmg file and follow the instructions.

After the installation is finished, you can start the VMware Fusion Player. You will be asked to enter your license key which will be there on the installation page.

After you have entered the license key, you will be asked to allow the kernel extensions. Click on `Open Security Preferences`.

In the Security & Privacy settings, click on `Allow` to allow the kernel extensions.

### Step 2: Install Ubuntu on VMware Fusion Player

Now we have to download the Ubuntu ISO image. Go to [Ubuntu 22.04.3](https://cdimage.ubuntu.com/jammy/daily-live/current/) and download the Ubuntu 22.04.3 LTS (Jammy Jellyfish) Daily Build. Make sure you download the `64-bit ARM (ARMv8/AArch64) desktop image`.

![Ubuntu ISO](Figs/ubuntu-iso.png)

After the download is finished, start the VMware Fusion Player. Click on `Create a New Virtual Machine`.

Now in Select the Installation Method, select `Install from disc or image` and click on `Continue`.

![VMware Fusion Player Create New Virtual Machine](Figs/vmware-fusion-player-create-new-virtual-machine.png)

Select `Use another disc or disc image...` and click on `Continue`. Now select the downloaded Ubuntu ISO image and click on `Open`.

![VMware Fusion Player Select ISO](Figs/vmware-fusion-player-select-iso.png)

Now click on `Continue`. In the next screen, make sure that 2 CPUs and 4 GB of RAM are selected. Click on `Finish`.

![VMware Fusion Player Finish](Figs/vmware-fusion-player-finish.png)

The VM will be created and started. After the VM is started, click on `Try or insall Ubuntu`.

![VMware Fusion Player Try or Install Ubuntu](Figs/vmware-fusion-player-try-or-install-ubuntu.png)

You will be greeted with Ubuntu home screen. As this is the test environment you will have to click on the `Install Ubuntu` icon on the desktop.

![Ubuntu Home Screen](Figs/ubuntu-home-screen.png)

During Installation select Minimal Installation and click on `Continue`.

![Ubuntu Installation](Figs/ubuntu-installation.png)

In the next screen, select `Erase disk and install Ubuntu` and click on `Install Now`.

![Ubuntu Installation](Figs/ubuntu-installation-erase.png)

Create a user with name `seed` and password `dees` and click on `Continue`.

![Ubuntu Installation](Figs/ubuntu-installation-user.png)

The installation will start. After the installation is finished, click on `Restart Now`.

If the is giving an error, just remove the ISO image from the VM and restart the VM. To do that go to `Virtual Machine` -> `Settings` -> `CD/DVD (SATA)` and uncheck `Connect CD/DVD Drive`. Click on `Apply` and `OK`. Now restart the VM.

![Ubuntu Installation](Figs/ubuntu-installation-cd.png)

Now you will be greeted with the home screen. Go to terminal download curl using ```sudo apt-get install curl``` and follow the setup instructions from step 2 in the [README](../../manuals/cloud/seedvm-cloud.md) file.

### Step 3: Setup Docker and Docker Compose

After done with the setup we have to set the docker default platform to linux/arm64. Go to terminal and type the following command.

```export DOCKER_DEFAULT_PLATFORM=linux/arm64```

Docker-compose is not available for arm64 architecture. So we have to install it manually. Go to terminal and type the following commands.

```sudo curl -L "https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose```

```sudo chmod +x /usr/local/bin/docker-compose```

Now you can use docker-compose in your VM.






