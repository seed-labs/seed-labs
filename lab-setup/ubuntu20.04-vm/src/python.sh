#!/bin/bash

# Python3.8 is already in the OS
echo "Installing Python and modules ..."

# Install Python3 modules 
sudo apt -y install python3-pip
sudo pip3 install scapy

# We can't install both pycryptodome and pycrypto, they conflict
sudo pip3 install pycryptodome
# sudo pip3 install pycrypto (don't install this one)

# Install Flask
sudo pip3 install Flask==1.1.1

# Install Python2 (some tools may need it)
sudo apt -y install python2
