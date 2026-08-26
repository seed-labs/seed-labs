#!/usr/bin/env bash
set -e

# ===============================
# Parameters:
#   --mode <cloud|desktop>       Installation mode
#   --user <username>            Username to install tools for (default: seed)
# ===============================

# Default values
MODE=""
USERID="seed"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --mode)
            MODE="$2"
            shift 2
            ;;
        --user)
            USERID="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 --mode <cloud|desktop> [--user <username>]"
            exit 1
            ;;
    esac
done

# Check mode argument   
if [[ "$MODE" != "cloud" && "$MODE" != "desktop" ]]; then
    echo "Error: --mode must be 'cloud' or 'desktop'"
    exit 1
fi

echo "Selected mode: $MODE"
echo "Installing tools for user: $USERID"

echo "Updating apt..."
sudo apt update

#------------------------------------------------
# Networking Tools
sudo apt -y install telnetd traceroute openbsd-inetd net-tools conntrack resolvconf make build-essential

#------------------------------------------------
# Utilities
sudo apt -y install ent eog execstack gcc-multilib gdb ghex libpcap-dev nasm unzip whois zip zsh

#------------------------------------------------
# Install VSCode / Firefox based on mode
if [[ "$MODE" == "cloud" ]]; then
    echo "=== Installing VSCode (deb version) ==="
    wget -qO /tmp/code.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
    sudo dpkg -i /tmp/code.deb || sudo apt-get install -f -y
    rm -f /tmp/code.deb

    echo "=== Handling Firefox (deb version) ==="
    if snap list | grep -q firefox; then
        echo "⚠️ Detected snap version of Firefox, uninstalling..."
        sudo snap remove firefox
    fi
    sudo add-apt-repository -y ppa:mozillateam/ppa
    sudo apt update
    echo 'Package: firefox*' | sudo tee /etc/apt/preferences.d/firefox.pref
    echo 'Pin: release o=LP-PPA-mozillateam' | sudo tee -a /etc/apt/preferences.d/firefox.pref
    echo 'Pin-Priority: 1001' | sudo tee -a /etc/apt/preferences.d/firefox.pref
    sudo apt -y install firefox
else
    echo "=== Installing VSCode (snap version) ==="
    sudo snap install --classic code
fi

#------------------------------------------------
# Misc tools
git clone https://github.com/longld/peda.git /tmp/gdbpeda
sudo cp -r /tmp/gdbpeda /opt
rm -rf /tmp/gdbpeda

# Wireshark setup
sudo apt -y install wireshark
sudo chgrp $USERID /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap

#------------------------------------------------
# Customization
HOMEDIR=/home/$USERID

sudo chown -R $USERID Files
sudo -u $USERID cp Files/System/seed_gdbinit $HOMEDIR/.gdbinit
sudo -u $USERID cp Files/System/seed_bash_aliases $HOMEDIR/.bash_aliases
sudo -u $USERID mkdir -p $HOMEDIR/.config/wireshark/
sudo -u $USERID cp Files/Wireshark/preferences $HOMEDIR/.config/wireshark/preferences
sudo -u $USERID cp Files/Wireshark/recent $HOMEDIR/.config/wireshark/recent
sudo cp -f Files/System/Background/* /usr/share/backgrounds/xfce/

#------------------------------------------------
echo "Cleaning up..."
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*

echo "***************************************"
echo "If you want to SSH into the $USERID account, set up public keys as described in the manual."
echo "***************************************"
