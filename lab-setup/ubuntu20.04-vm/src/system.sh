#!/bin/bash

echo "Configuring the system ..."
FileDir=Files/System


#-------------------------------------------------------------
# Copy the .bashrc file 
cp $FileDir/seed_bashrc  ~/.bashrc



#-------------------------------------------------------------
# Set up the background image
sudo cp $FileDir/seed-vm-background-tesla-coil.jpg /usr/share/background
sudo cp $FileDir/focal-wallpapers.xml /usr/share/gnome-background-properties


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
# Cleanup 

unset FileDir FirefoxProfileDir

