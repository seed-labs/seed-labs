# Creating a SEED Ubuntu 24.04 VM on the Cloud or Desktop

This folder contains the instructions on how to build the SEED Ubuntu 24.04 VM. 


## Step 1: Create a VM Instance

First we need to create an VM instance, and install the Ubuntu 24.04 LTS operating system on the VM. The minimal machine configuration is 2 CPU cores, 4GB of RAM, and 10GB of disk space. If you feel that the performance is not good enough, you can always change the machine configuration later.

- For desktop, we suggest users to use VirtualBox to create VM. We also suggest users to allocate more disk spaces (the 10GB minimal disk space is meant for cloud VM to reduce the cloud expense). 

- For cloud, most could providers should work, including Amazon AWS, Google Cloud, Microsoft Azure, Alibaba Cloud, Digital Ocean, etc. Users should be able to find online manuals regarding how to create a VM instance on a particular cloud platform.


## Step 2: Install Software and Configure System

After creating the Ubuntu 24.04 VM, we need to install all the necessary software on the VM. When the Ubuntu 24.04 VM is built, a default username with the root privilege will be created in the system. The actual name of the user is typically chosen by the cloud operator. Most cloud platforms will provide a method for you to SSH into this account. 

Download or git clone this project into your VM, and `cd` into `labsetup/ubuntu24.04-vm/installation` folder, run the following command to install software and configure the system.

```
./install.sh
```

- **Note:** This shell script will download and install all the software needed for the SEED labs. The whole process will take a few minutes. Please don't leave, because you will be asked to make choices:

  - During the installation of `vscode`, you will be asked
    whether to add Microsoft apt repository for Visual Studio Code?
    Select `No`.

  - During the installation of Wireshark, you will be asked
    whether non-superuser should be able to capture packets.
    Select `No`.

  - During the installation of `xfce4`, you will be asked to
    choose a default display manager. Choose `LightDM`.



After the script finishes, a new account called `seed` will be created, We will use this account for all the SEED labs, instead of the default one
created by the cloud. We intentionally did not set a password for this account, so nobody can directly log into this account. We can switch to the `seed` account using the following command (if you do not use `sudo`, the OS
will ask you to type the password, making it impossible to log in):
```
sudo su seed
```

## Step 3 (Option A): Access the VM Using VNC

For most labs, being able to SSH into the VM should be sufficient.
Some labs do need to access GUI applications on the VM, such as
Firefox and Wireshark. If your network bandwidth is not too
bad, being able to get a graphical desktop of the remote VM is
always more desirable than getting a text terminal via SSH.
We will use VNC (Virtual Network Computing) to get the remote
desktop.

- **On the cloud VM:** We need to make sure that we are in
  the `seed` account. If you are still in the default account, do
  the following, and you will be in the `seed` account:
  ```
  sudo su seed
  ```

  Our installation script has already installed
  the TigerVNC server program on the VM. You need to start the
  server.
  ```
  tigervncserver :1 -localhost no -geometry 1920x1080 -depth 24 -xstartup /usr/bin/startxfce4
  ```  

  By default, TigerVNC server only listens to localhost/127.0.0.1. The
  purpose of the `-localhost no` option means accepting access from the
  outside. When we first start the `tigervncserver`, we will be asked to provide a password. Make sure this password is strong enough. Moreover, VNC
  communication itself is not encrypted, so you should not send anything
  personal. If you do want to secure it, you can run an SSH tunnel or VPN
  tunnel to protect the VNC communication.

- **On your computer:** You need to have a VNC viewer installed on your computer, such as [TigerVNC](https://tigervnc.org/), and
  [RealVNC](https://www.realvnc.com/en/connect/download/viewer/). If you prefer other VNC viewers, it is fine. Most of them are compatible with one another. Some users have reported that TigerVNC have issues on macOS,
  but RealVNC has no problem.

  Start your VNC viewer program, and type the IP address of the VM, along with the port number, such as `35.236.203.131:5901`. Most cloud VMs have two IP addresses; make sure you use the external (public) IP address, not the internal (private) one. You will be prompted for password, which is the one you typed when you first run the VNC server. If everything is done correctly, your remote VM.

- If you VNC does not work, check your firewall to make sure TCP traffics
  to the port `5901` on the VM is allowed. Also check whether your VNC server
  is running properly. Here are some useful commands to help you manage the VNC server on the VM:
  ```
  vncserver -list       # List the VNC server sessions
  vncserver -kill :1    # Kill the session for :1 display
  ```
## Step 3 (Option B): Access the VM Using Web VNC
You can use the web novnc proxy to access the VM using a web browser,
here are how to deploy the novnc proxy:

```
sudo su root
./deploy_novnc.sh -p vncpassword
```
The web noVNC proxy has been installed on the VM and listens on port `6080`. 
You can customize the vncpassword and access the web noVNC proxy through the following URL:
```
http://<VM_IP>:6080/vnc.html
```
**Note:** To install the web noVNC proxy, you must use Ubuntu 24.04 Server Edition. 
The Ubuntu 24.04 Desktop Edition is currently not compatible with this setup.

## Step 3 (Option C): Access the VM Using SSH

To run VNC, you need to have reasonable bandwidth. If your VNC performance
is bad, you should switch to SSH. You can get by with many of the
SEED labs using just terminals. There are many ways to SSH into the
cloud VM:

- Most cloud platforms provide a default browser-based SSH client.
  Google cloud's SSH client even allows you to upload and download files,
  which is very convenient.

- You can also find many third-party SSH clients. Some clouds may have
  disabled the password authentication in SSH, so you have to use
  public keys for the authentication. You need to generate public/private key pairs on your SSH client machine, and save the public key into the `/home/seed/.ssh/authorized_keys` file on the server machine. You can easily find instructions from online resources, so we will not provide one here.


## Notes on Cost

Unless you have a special deal with cloud company, you will be charged for using the cloud VM. Please keep an eye on your bill, because sometimes, there are costs that you may not be aware of, such as bandwidth cost, storage cost, etc. Understanding where your expense is can help you reduce it. Moreover, to avoid wasting money, remember to suspend your VMs if you are not working on them. Although a suspended VM still incurs storage cost (usually very small), it does not incur any computing costs. You can easily resume them when you are ready to continue your work.