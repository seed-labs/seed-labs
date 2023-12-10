#!/bin/bash 

echo "Installing VirtualBox Guest Addtion ..."

sudo add-apt-repository multiverse
sudo apt -y install virtualbox-guest-dkms virtualbox-guest-x11

