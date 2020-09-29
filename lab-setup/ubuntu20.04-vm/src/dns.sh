#!/bin/bash

echo "Installing and configuring BIND 9 ..."
FileDir=Files/DNS

# Install bin9 and resolvconf
sudo apt -y install bind9
sudo apt -y install resolvconf

# Copy the configuration file
sudo cp $FileDir/named.conf.options /etc/bind/named.conf.options

# Restart bind9
sudo service bind9 restart

# Cleanup
unset FileDir

