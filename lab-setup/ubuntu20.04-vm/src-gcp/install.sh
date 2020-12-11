#!/bin/bash

# Store the user ID to this variable
USERID=$(whoami)

# We need to get the real user ID information, so 
# we cannot run this script using "sudo".
if [[ $USERID = "root" ]]; then
   echo "Please don't run this program using 'sudo'."
   echo "Exiting ... Please run it again."
   exit 0
fi


sudo apt update

#================================================
echo "Installing various tools ..."

#------------------------------------------------
# Networking Tools

sudo apt -y install telnetd
sudo apt -y install traceroute
sudo apt -y install openbsd-inetd

# net-tools include arp, ifconfig, netstat, route etc.
sudo apt -y install net-tools

# For Firewalls lab
sudo apt -y install conntrack

# For DNS
sudo apt -y install resolvconf

# Install browser
sudo apt -y install firefox

#------------------------------------------------
# Utilities

sudo apt -y install bless
sudo apt -y install ent
sudo apt -y install execstack
sudo apt -y install gcc-multilib
sudo apt -y install gdb
sudo apt -y install ghex
sudo apt -y install libpcap-dev
sudo apt -y install nasm
sudo apt -y install unzip
sudo apt -y install whois
sudo apt -y install zip
sudo apt -y install zsh

# Install vscode if needed 
sudo snap install --classic code

# sudo apt -y install vim  (already in the system)
# sudo apt -y install git  (already in the system)
# sudo apt -y install curl (already in the system)
# tcpdump is in the system


#================================================
# Python3.8 is already in the OS
echo "Installing Python and modules ..."

# Install pip3 and Python3 modules 
sudo apt -y install python3-pip
sudo pip3 install scapy
sudo pip3 install pycryptodome


#================================================
echo "Installing miscellaneous tools ..."

# Install gdbpeda (gdb plugin)
git clone https://github.com/longld/peda.git /tmp/gdbpeda
sudo cp -r /tmp/gdbpeda  /opt
echo "source /opt/gdbpeda/peda.py" >> ~/.gdbinit
rm -rf /tmp/gdbpeda


#================================================
echo "Installing docker utilities ..."
  
# Install docker
sudo apt -y install docker.io

# Start docker and enable it to start after the system reboot:
sudo systemctl enable --now docker

# Optionally give any user administrative privileges to docker:
sudo usermod -aG docker $USERID

# Install docker-compose. Check whether 1.27.4 is the newest version
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose


#================================================
echo "Installing Wireshark ..."

#--------------------------------------------------------------------
# Install Wireshark
# Make sure to select 'No' when asked whether non-superuser should be
#      able to capture packets.

sudo apt -y install wireshark
sudo chgrp $USERID /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap

#--------------------------------------------------------------------
# Copy the configuration files

mkdir -p ~/.config/wireshark/
cp Files/Wireshark/preferences ~/.config/wireshark/preferences
cp Files/Wireshark/recent ~/.config/wireshark/recent


#================================================
echo "Installing software for the cloud VM ..."

# Instal a light-weighted window manager.
# It will ask us to choose a default display manager, chose LightDM. 
sudo apt -y install xfce4 xfce4-goodies

# Copy the program launcher icons to the desktop
mkdir -p ~/Desktop
cp Files/System/Desktop/*  ~/Desktop
chmod u+x ~/Desktop/*.desktop

# Copy the desktop image files
sudo cp -f Files/System/Background/* /usr/share/backgrounds/xfce/

# Install TigerVNC server, and copy the configuration file
sudo apt -y install tigervnc-standalone-server tigervnc-xorg-extension
mkdir -p ~/.vnc
cp Files/System/vnc_xstartup ~/.vnc/xstartup
chmod u+x ~/.vnc/xstartup


#================================================
echo "Configuring the system ..."

# We have defined a few aliases for the SEED labs
cp Files/System/seed_bash_aliases  ~/.bash_aliases
. ~/.bashrc


#================================================
echo "Cleaning up ..."

# Clean up the apt cache 
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*
