# XSS Attack Lab


## Porting to Ubuntu 20.04

This lab works on both Ubuntu 16.04 and 20.04 VM.
When porting this lab to 20.04, 
we did spend quite a bit of time to modify the Elgg web application,
so vulnerabilities are introduced. However, 
no change is needed for the lab description.

During the revision, we have significantly revised the CSP task. In the 
revision, we use two ways to set CSP header: (1) Apache
configuration, (2) PHP code. 


## For Container Setup

We have moved the Elgg setup to containers, and our Ubuntu 20.04 VM 
will no longer host the Elgg website. Since we only need
a browser on the VM, this lab can be done using 
generic machines, no longer depending on our VM. 


## Labsetup

- `Labsetup`: use the pre-built SEED image stored in Docker Hub. The image 
  is the original Elgg image, which needs to be customized for this lab.
  All the customization files are included in the `Labsetup/elgg` folder.
