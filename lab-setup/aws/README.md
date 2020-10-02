# SEEDUbuntu 16.04 AWS setup instructions
Author: Steve Cole (svcole@wustl.edu)
Washington University in St. Louis

## Overview

I have created an AWS AMI (Amazon Machine Image) derived from the
SEEDUbuntu-16.04-32bit .vmdk-format image provided on the [SEED Lab setup
page](https://seedsecuritylabs.org/lab_env.html).  The original image
has been augmented with extra software packages and configurations to
make it AWS friendly.  The configurations allow remote GUI access to an
instance launched from the AMI and strengthen the security of the
instance for the public-accessibility context.  

_Note_: The AMI is currently available as a "community" AMI in the
us-east-1, us-west-1, and ap-east-1 regions under the name
"SEEDUbuntu-aws."

## Process used to create AMI      

1. Create a SEEDUBuntu VM in VirtualBox according to the SEED Lab
instructions.  
2. Export the VM image as an .ova archive from VirtualBox .  (See
"Exporting an OVA"
[here](https://www.maketecheasier.com/import-export-ova-files-in-virtualbox/)).    
3. Import the .ova image into AWS as an AMI using [these
instructions](https://aws.amazon.com/ec2/vm-import/) .   
4. Launch an instance from the AMI.    
5. Copy a custom configuration script onto the AMI (more details
below).    
6. Run the config script as root on the AMI (using sudo).    
7. Do extra config ops—replace Wireshark, give non-root access to
network traffic for Wireshark, disable xfce4 option that prevents tab
completion from working.  See config script for details.
8. Save the (running) instance as a new AMI using [these
instructions](https://docs.aws.amazon.com/toolkit-for-visual-studio/latest/user-guide/tkv-create-ami-from-instance.html)
.  _It is critical that the instance still be running when
the new AMI is created in order to preserve the configuration changes._
9. Now the AMI can be used to launch a pre-configured SEEDUbuntu
image anytime.

## Changes made to baseline SEEDUbuntu image in new AMI    

1. Change default memory allowance to 4GB.   
2. Update packages.   
3. Install xrdp to allow remote access via RDP over port 5901.    
4. Install xfce4 and set it to be the Desktop Manager used in
remote access.    
5. Add /home/seed/bin and /sbin to PATH (happens already for SSH
login but not upon xrdp login for some reason).    
6. Fix misconfiguration bug in xfce4 that prohibits tab completion
in terminals (must be done manually outside script).    
7. Uninstall default Wireshark; reinstall wireshark-gtk.     
8. Give non-root user access to raw network packets so Wireshark
will work (must be done manually outside script).    
9. Change the default password for the "seed" user account to be
more secure.  The new password is "**5sFr7%93#PJY**" (without the quotes).
10. Force user to change password after first login.    
11. Add /sbin to path so user can execute “ifconfig” .     

## How to Launch SEEDUbuntu VM

Note: Steps 1-2 are only needed for setting up multiple SEEDUbuntu
instances on the same local (virtual) subnet.  For setting up a single
SEEDUbuntu instance, these steps may be skipped.    

1. Create a new VPC (under Services -> VPC in AWS; VPCs are
distinct from EC2).  Set the CIDR block to 10.0.0.0/16.   
2.	Create a new VPC subnet in the region in which the custom AMI
image is available (currently us-east-1f).  Be sure to select the VPC
just created in the previous step.  Give the subnet the CIDR block
10.0.0.0/24.    
 
3.	Create a security group with the following rules:    
- Inbound: allow  TCP ports 22 (for SSH access) and 5901 (for
remote desktop access via xrdp on custom port), (any traffic from local
subnet (10.0.0.0/24) if using multiple machines only)
b.     
- Outbound: allow TCP ports 22 (SSH), 5901 (xrdp on custom port),
80, and 443 (so we can access the Internet from inside the SEED
machine), ICMP for pings anywhere, UDP anywhere for DNS, (any traffic to
local subnet (10.0.0.0/24) if using multiple machines only)

4. Launch a new instance with a configuration that includes the
following: 
- the custom AMI, which can be found by searching for
 “SEEDUbuntu-aws” in the “Community” section of AMI options.
_NOTE_: this AMI is currently available in the regions us-east-1,
us-west-1, and ap-south-1 .  If you would like to create an instance in
a different region, please contact Steve Cole.    
- a suitable instance type (t4.medium recommended to give 4GB RAM
 and is the only instance tested so far, but smaller instances
 may be fine)    
- the security group you created in Step 3    
- the VPC subnet you created in Step 2 (if setting up multiple
	machines on same local subnet).      

## First Access to SEEDUbuntu Instance

Once an instance is launched with the above configuration, do the
following:    

1. SSH to the instance using the AWS public IP assigned to the
instance; e.g., "ssh seed@3.4.5.6" .    
2. Enter the updated default password when prompted (NOT the same
as the default password in the original SEEDUbuntu image!).  The
password is "**5sFr7%93#PJY**" (without the quotes).    
3. Follow prompts to choose a new password.  Note that the system
will automatically log you out if password is successfully changed.   
4. Log in again using your new password to verify that it works.    
5. You can now log in via SSH for command-line access or RDP for
GUI Desktop access.    

## Remote Desktop Access to SEEDUbuntu Instance

Note: you must complete initial login via SSH according to instructions
above BEFORE logging in via RDP.    

1. Open a remote desktop client that can use RDP (e.g. "Remote Desktop
Connection" in Windows or "Microsoft Remote Desktop" on a Mac).    
2. Instantiation a new connection to the IP address of the AWS
image at port 5901; e.g., 3.4.5.6:5901 .   
3. Log in as the "seed" user with your new password.    
4. Note that the first time you log in, you may see an error and be
immediately disconnected.  If this happens, connect again and your login
should succeed.    
5. You should see the SEEDUbuntu desktop as usual, with a few
slight changes due to using xfce4 as the desktop manager rather than the
default Ubuntu desktop manager.   
 
- Note in particular that the "Terminal" application does not appear in
  the sidebar.  You can either use the "Terminator" app in the sidebar,
or open "Applications -> System" and select one of the terminal
emulators from the list, or search for "terminal" in the application
search tool in the toolbar (represented by the magnifying glass) and
select a terminal emulator.


## Testing local network configuration (if setting up multiple machines on same subnet):

1. Create 2 instances according to the above instructions and log
in either via ssh or RDP.    
2. Open a terminal on each instance and run "ifconfig -a" .  You
should see an interface with IPv4 address 10.0.0.x for some (unique) x
for each machine.    
3. Run "ping –c 5 10.0.0.x" from each machine, using the other
machine’s IP address found in the previous step.  You should see 5
results printing on the terminal one per second; if so, then the ping
was successful.   

