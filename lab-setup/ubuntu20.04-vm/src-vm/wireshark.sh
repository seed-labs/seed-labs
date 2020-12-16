#!/bin/bash

echo "Installing Wireshark ..."
FileDir=Files/Wireshark

#--------------------------------------------------------------------
# Install Wireshark
# Make sure to select 'No' when asked whether non-superuser should be
#      able to capture packets.

sudo apt -y install wireshark
sudo chgrp seed /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap


#--------------------------------------------------------------------
# Copy the configuration files

mkdir -p ~/.config/wireshark/
cp $FileDir/preferences ~/.config/wireshark/preferences
cp $FileDir/recent ~/.config/wireshark/recent


#--------------------------------------------------------------------
# Cleanup

unset FileDir
