# Creating a VM Instance on DigitalOcean


Creating a VM instance on DigitalOcean is quite straightforward.
When you create the VM instance, we suggest the following parameters:

## Step 1: Create a new project

First you need to create a new project and fill up the basic project information

![machine configuration](./Figs/dig-create-project.png)

for now, because we don't have existing Droplet, we skip moving the resource into project.

![machine configuration](./Figs/dig-create-project2.png)

## Step 2: Create a new Droplet

Once we have created the project, we create a droplet in it.

![machine configuration](./Figs/dig-create-droplet.png)

choose Ubuntu 20.04LTS operating system

![machine configuration](./Figs/dig-create-droplet2.png)

1 CPU and 2GB is sufficient for most SEED labs. You can easily change the machine configuration later after the machine is created.

![machine configuration](./Figs/dig-create-droplet3.png)

Set the root password

![machine configuration](./Figs/dig-create-droplet4.png)

keep the other parameters as default and create the droplet.

![machine configuration](./Figs/dig-create-droplet5.png)

The droplet is successfully created and return the basic information about VM

![machine configuration](./Figs/dig-create-droplet6.png)

## Step 3: Access your VM

DigitalOcean provides a default browser-based SSH client for your VM.

![machine configuration](./Figs/dig-access-VM.png)


![machine configuration](./Figs/dig-access-VM2.png)

login the VM with root account, and enter the password you just set when you create
the droplet(VM). Note that when you are entering the password, the console will not response. Once you enter the correct password and press the ENTER key, you will login the VM successfully.


![machine configuration](./Figs/dig-access-VM3.png)

![machine configuration](./Figs/dig-access-VM4.png)


## NOTE: VNC issue

There is an issue you may met when you have configured the SEED lab environment. When you restart your VM, the DigitalOcean default browser-based SSH client will show as following:

![machine configuration](./Figs/dig-VNC-issue.png)

You can't directly log into the seed account because it doesn't have password. For some reason, there is distance between your mouse moving and server moving, so you also can't switch to the root account to log in. In this senario, you can't start the VNC server through the DigitalOcean default browser-based SSH client.

But you can still login root account by your local terminal.

![machine configuration](./Figs/dig-VNC-issue2.png)
