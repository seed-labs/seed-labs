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

sudo apt -y install tigervnc-standalone-server tigervnc-xorg-extension dbus-x11 xauth


echo "=== 配置 LightDM 自动登录 seed 用户 ==="
sudo mkdir -p /etc/lightdm/lightdm.conf.d
cat <<EOF | sudo tee /etc/lightdm/lightdm.conf.d/50-seed-autologin.conf
[Seat:*]
autologin-user=seed
autologin-user-timeout=0
user-session=xfce
EOF

echo "=== 设置 xfce4 为默认桌面环境 ==="
echo "xfce4-session" | sudo tee /home/seed/.xsession
sudo chown -R seed:seed /home/seed
echo "=== 确保 LightDM 启动并设为默认 ==="
sudo systemctl enable lightdm
sudo systemctl set-default graphical.target

echo "=== 给予 seed 用户图形权限 ==="
sudo usermod -aG video,render,plugdev,cdrom,users seed

echo "=== 完成！重启后将自动登录 seed 用户并进入 xfce4 桌面 ==="