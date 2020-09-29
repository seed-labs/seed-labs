#!/bin/bash

echo "Configuring the system ..."
FileDir=Files/System


#-------------------------------------------------------------
# Copy the .bashrc file 
cp $FileDir/seed_bashrc  ~/.bashrc


#------------------------------------------------------------------
# Copy user-account profile 

cp $FileDir/config_user  ~/.config/dconf/user

# Note: if we have copied the "user" file to ~/.config/dconf,
#       we don't need to run the following commands. 

# First time, after configuring Gnome-Terminal, save the setting
# dconf dump /org/gnome/terminal/ > gnome_terminal_settings.txt

# Load the prestored setting
# dconf load /org/gnome/terminal/ < gnome_terminal_settings.txt


#------------------------------------------------
# Copy system files 
sudo cp $FileDir/etc_sudoers  /etc/sudoers
sudo cp $FileDir/etc_hosts   /etc/hosts

# Disable the "internal error" message 
sudo cp $FileDir/etc_default_apport  /etc/default/apport


#------------------------------------------------
# Configure Firefox
# Need to manually find the value of tttt (the name is generated)
FirefoxProfileDir=tttt
cp $FileDir/firefox_profile_user.js  ~/.mozilla/firefox/$FirefoxProfileDir/user.js


#------------------------------------------------
# Enabling service
# sudo systemctl enable ssh  (no need)
# sudo systemctl enable openbsd-inetd (no need)

#------------------------------------------------
# Cleanup 

unset FileDir FirefoxProfileDir

