# Creating a VM Instance on Google Cloud


Creating a VM instance on Google cloud is quite straightforward.
When you create the VM instance, we suggest the following parameters:

## Step 1: Machine configuration 

2 vCPU and 4GB of memory is more desirable. However, 
one vCPU and 2GB is sufficient for most SEED labs. You can
easily change the machine configuration later after the machine
is created. 

![machine configuration](./Figs/gcp_machine_config.jpg)


## Step 2: Boot disk 

Choose the Ubuntu 20.04 LTS operating system.
For the disk size, 20 GB is more desirable, but 10 GB will work.

![machine configuration](./Figs/gcp_boot_disk.jpg)


## Step 3: Set up Firewall

Will be added soon ...


## Notes

Keep an eye on your bill. Sometimes, there are costs that you may 
not be aware of, such as bandwidth cost, storage cost, etc. 
Understanding where your expense is can help you reduce it. 
Moreover, to save cost, please remember to 
suspend your VMs if you are not working on them. Although a 
suspended VM still incurs storage cost (usually very small), it 
does not incur any computing costs. You can easily resume them
when you are ready to continue your work.
