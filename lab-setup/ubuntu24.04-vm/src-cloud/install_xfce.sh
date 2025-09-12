#!/bin/bash
#========================================================
# Script to install XFCE4 desktop environment and TigerVNC server on Ubuntu
#========================================================

# Exit immediately if a command exits with a non-zero status
set -e

echo "========================================"
echo "Installing XFCE4 Desktop Environment..."
echo "You may be asked to choose a default display manager, please select LightDM."
echo "========================================"

sudo apt update
sudo apt -y install xfce4 xfce4-goodies

echo "========================================"
echo "Installing TigerVNC Server..."
echo "========================================"

sudo apt -y install tigervnc-standalone-server tigervnc-xorg-extension

echo "========================================"
echo "Installation completed!"
echo "You can now configure VNC server for remote desktop access."
echo "========================================"
sudo usermod -aG nopasswdlogin seed
# 或者
sudo usermod -aG nopasswdlogin ubuntu
sudo systemctl restart lightdm