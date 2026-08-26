#!/bin/bash
#========================================================
# Script to install XFCE4 desktop environment and TigerVNC server on Ubuntu
#========================================================

# Exit immediately if a command exits with a non-zero status
set -e
sudo apt update && sudo apt upgrade -y
echo "========================================"
echo "Installing XFCE4 Desktop Environment..."
echo "You may be asked to choose a default display manager, please select LightDM."
echo "========================================"

sudo apt update
sudo apt -y install xfce4 xfce4-goodies 

echo "========================================"
echo "Installing TigerVNC Server..."
echo "========================================"

sudo apt -y install tigervnc-standalone-server tigervnc-xorg-extension dbus-x11 xauth xterm


# echo "=== Configuring LightDM to auto-login seed user ==="
# sudo mkdir -p /etc/lightdm/lightdm.conf.d
# cat <<EOF | sudo tee /etc/lightdm/lightdm.conf.d/50-seed-autologin.conf
# [Seat:*]
# autologin-user=seed
# autologin-user-timeout=0
# user-session=xfce
# EOF

# echo "=== Setting xfce4 as default desktop environment ==="
# echo "xfce4-session" | sudo tee /home/seed/.xsession
# sudo chown -R seed:seed /home/seed
# echo "=== Ensuring LightDM starts and is set as default ==="
# sudo systemctl enable lightdm
# sudo systemctl set-default graphical.target

# echo "=== Giving seed user graphical permissions ==="
# sudo usermod -aG video,render,plugdev,cdrom,users seed

