# Lab Setup for Apple Silicon Machines

We are now ready to install all the software packages needed for the SEED labs.

<font color="red">Do not upgrade your Ubuntu version!</font>

- [Step 1: Setup Bidirectional Shared Clipboard](#set-up/)
- [Step 2: Install the Software](#install)

## Step 1: Setup Bidirectional Shared Clipboard

In the default setting, the copy-and-paste does not work between your host Apple machine and the VM running inside VMware Fusion. This is quite inconvenient. You can install `vmware tools` to set up a bidirectional shared clipboard. Run the following commands.

```
sudo apt-get upgrade
sudo apt-get install open-vm-tools-desktop -y
sudo reboot
```
***
## <a id="install"></a>Step 2: Install the Software

Go to terminal, first download `curl` using

```
sudo apt-get install curl
```

Download [`src-arm.zip`](https://seedsecuritylabs.org/setup/src-arm.zip) from the link or using the following `curl` command.

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
  sudo ./install.sh
  ```

- **Note:** This shell script will download and install all the software needed for
  the SEED labs. The whole process will take a few minutes. Please
  don't leave, because you will be asked twice to make choices:

  - During the installation of Wireshark, you will be asked
    whether non-superuser should be able to capture packets.
    Select `No`.

  - During the installation of `xfce4`, you will be asked to
    choose a default display manager. Choose `LightDM`.


After the script finishes, we can switch to the `seed` account using the following command:

```
sudo su seed
```
