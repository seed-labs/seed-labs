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

sudo apt install -y make
sudo apt install -y build-essential
# Install vscode 

# Install vscode 
# sudo snap install --classic code
if [ "$MODE" = "cloud" ]; then
    echo "=== Installing VSCode (deb version) ==="
    wget -qO /tmp/code.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
    sudo dpkg -i /tmp/code.deb || sudo apt-get install -f -y
    rm -f /tmp/code.deb

    echo "=== Handling Firefox (uninstall snap version, install deb version) ==="

    # If snap version of Firefox exists, uninstall it
    if snap list | grep -q firefox; then
        echo "⚠️ Detected snap version of Firefox, uninstalling..."
        sudo snap remove firefox
    fi
    echo "=== Installing Firefox (deb version) ==="
    # Add official PPA (non-interactive)
    sudo add-apt-repository -y ppa:mozillateam/ppa
    sudo apt-get update
    # Force use deb package, avoid snap version
    echo 'Package: firefox*' | sudo tee /etc/apt/preferences.d/firefox.pref
    echo 'Pin: release o=LP-PPA-mozillateam' | sudo tee -a /etc/apt/preferences.d/firefox.pref
    echo 'Pin-Priority: 1001' | sudo tee -a /etc/apt/preferences.d/firefox.pref
    sudo apt-get install -y firefox
else
    echo "=== Installing VSCode (snap version) ===" 
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
# Copy the desktop image files
sudo cp -f Files/System/Background/* /usr/share/backgrounds/xfce/



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