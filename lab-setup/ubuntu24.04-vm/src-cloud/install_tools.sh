#!/usr/bin/env bash
# Interactive prompt
USERID=seed
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
echo "Installing various tools ..."

sudo apt update

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
# sudo apt -y install firefox

#------------------------------------------------
# Utilities
# sudo snap install bless

# sudo apt -y install bless
sudo apt -y install ent
sudo apt -y install eog
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

# Install vscode 

# Install vscode 
# sudo snap install --classic code
if [ "$MODE" = "cloud" ]; then
    echo "=== 安装 VSCode (deb 版) ==="
    wget -qO /tmp/code.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
    sudo dpkg -i /tmp/code.deb || sudo apt-get install -f -y
    rm -f /tmp/code.deb

    echo "=== 处理 Firefox (卸载 snap 版，安装 deb 版) ==="

    # 如果存在 snap 的 Firefox，先卸载
    if snap list | grep -q firefox; then
        echo "⚠️ 检测到 snap 版 Firefox，正在卸载..."
        sudo snap remove firefox
    fi
    echo "=== 安装 Firefox (deb 版) ==="
    # 添加官方 PPA（非交互）
    sudo add-apt-repository -y ppa:mozillateam/ppa
    sudo apt-get update
    # 强制使用 deb 包，避免 snap 版本
    echo 'Package: firefox*' | sudo tee /etc/apt/preferences.d/firefox.pref
    echo 'Pin: release o=LP-PPA-mozillateam' | sudo tee -a /etc/apt/preferences.d/firefox.pref
    echo 'Pin-Priority: 1001' | sudo tee -a /etc/apt/preferences.d/firefox.pref
    sudo apt-get install -y firefox
else
    echo "=== 安装 VSCode (snap 版) ==="
    sudo snap install --classic code
fi


#================================================
echo "Installing miscellaneous tools ..."

# Install gdbpeda (gdb plugin)
git clone https://github.com/longld/peda.git /tmp/gdbpeda
sudo cp -r /tmp/gdbpeda /opt
rm -rf /tmp/gdbpeda



#================================================
echo "Installing Wireshark ..."

# Install Wireshark
# Make sure to select 'No' when asked whether non-superuser should be
#      able to capture packets.
sudo apt -y install wireshark
sudo chgrp $USERID /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap



echo "Customizatoin ..."

HOMEDIR=/home/$USERID
DESKTOP_DIR=$HOMEDIR/Desktop

# Change the own of this folder (and all its files) to $USERID,
# because we need to access it from the $USERID account. This 
# guarantees that the "sudo -u $USERID cp Files/..." command will work.
sudo chown -R $USERID Files


# Install gdbpeda (gdb plugin)
sudo -u $USERID cp Files/System/seed_gdbinit $HOMEDIR/.gdbinit

# We have defined a few aliases for the SEED labs
sudo -u $USERID cp Files/System/seed_bash_aliases $HOMEDIR/.bash_aliases

# Customization for Wireshark
sudo -u $USERID mkdir -p $HOMEDIR/.config/wireshark/
sudo -u $USERID cp Files/Wireshark/preferences $HOMEDIR/.config/wireshark/preferences
sudo -u $USERID cp Files/Wireshark/recent $HOMEDIR/.config/wireshark/recent


# Create launcher icons on the desktop
# sudo -u $USERID mkdir -p $HOMEDIR/Desktop
# sudo -u $USERID cp Files/System/Desktop/*  $HOMEDIR/Desktop
# sudo -u $USERID chmod u+x $HOMEDIR/Desktop/*.desktop
# sudo -u $USERID mkdir -p $HOMEDIR/.local/share/icons
# sudo -u $USERID cp Files/System/Icons/*  $HOMEDIR/.local/share/icons


# # 设置 trusted 标记
# for file in $DESKTOP_DIR/*.desktop; do
#     sudo -u $USERID gio set "$file" "metadata::trusted" true
# done

# # Copy the desktop image files
# sudo cp -f Files/System/Background/* /usr/share/backgrounds/xfce/

# # Configure the VNC server 
# sudo -u $USERID mkdir -p $HOMEDIR/.vnc
# sudo -u $USERID cp Files/System/vnc_xstartup $HOMEDIR/.vnc/xstartup
# sudo -u $USERID chmod u+x $HOMEDIR/.vnc/xstartup

#================================================
echo "Cleaning up ..."

# Clean up the apt cache 
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*


#================================================
echo "***************************************"
echo "If you want to be able to SSH into the seed account, you need to set up public keys."
echo "You can find the instruction in the manual."
echo "***************************************"