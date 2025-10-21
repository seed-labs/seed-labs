#!/bin/bash

#=================================================================
# Most cloud platforms create a default account in the system.
# We will not use this account for SEED labs. Instead, we will
# create a new account called "seed", give it the privilege
# to run "sudo" commands. 
#=================================================================

#================================================
# Create a user account called "seed" if it does not exist. 
# For security, we will not set the password for this account, 
# so nobody can ssh directly into this account. You need to 
# set up public keys to ssh directly into this account if you use ECS.
# if you use ubuntu24.04 desktop version,you will be asked to set a password 
# for seed user account.

# Interactive prompt
echo "Please choose installation type:"
echo "  1) Cloud mode (install XFCE desktop + TigerVNC)"
echo "  2) Desktop mode (skip desktop/VNC installation)"
while true; do
    read -rp "Enter 1 or 2 and press Enter: " CHOICE
    case "$CHOICE" in
        1) MODE="cloud"; break ;;
        2) MODE="desktop"; break ;;
        *) echo "Invalid input, please enter 1 or 2." ;;
    esac
done

echo "You selected: $MODE mode"
# Set the USERID shell variable.
sudo useradd -m -s /bin/bash seed 
# Allow seed to run sudo commands without password
sudo cp Files/System/seed_sudoers  /etc/sudoers.d/
sudo chmod 440 /etc/sudoers.d/seed_sudoers
if [ "$MODE" = "desktop" ]; then
    echo "!!! Please et password for seed user account"
    sudo passwd seed
fi

USERID=seed

echo "🔧 Installing Docker..."
sudo bash ./install_docker.sh

if [ "$MODE" == "cloud" ]; then
    echo "🔧 Installing XFCE4 Desktop and TigerVNC..."
    sudo bash ./install_xfce.sh
fi

echo "========================================"
echo "Installing conda env "
echo "========================================"
sudo bash ./install_conda.sh


if [ "$MODE" == "cloud" ]; then
    echo "🔧 Installing software tools for the cloud VM..."
    sudo bash ./install_tools.sh --mode cloud
else
    echo "🔧 Installing software tools for the desktop VM..."
    sudo bash ./install_tools.sh --mode desktop
fi
sudo reboot