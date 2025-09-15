#!/bin/bash
#========================================================
# Script to install VS Code, Firefox, Wireshark on Ubuntu 24.04
# and put desktop icons in XFCE desktop
# Wireshark requires sudo to run
#========================================================

set -e

DESKTOP="$HOME/Desktop"

echo "========================================"
echo "Updating system packages..."
echo "========================================"
sudo apt update
sudo apt -y upgrade


# For Firewalls lab
sudo apt -y install conntrack

# For DNS
sudo apt -y install resolvconf

# Install browser
sudo apt -y install firefox

#--------------------------------------------------------
# 1. Install VS Code
#--------------------------------------------------------
echo "========================================"
echo "Installing VS Code..."
echo "========================================"
sudo apt -y install software-properties-common apt-transport-https wget

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
rm packages.microsoft.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt update
sudo apt -y install code

#--------------------------------------------------------
# 2. Install Firefox
#--------------------------------------------------------
echo "========================================"
echo "Installing Firefox..."
echo "========================================"
sudo apt -y install firefox

#--------------------------------------------------------
# 3. Install Wireshark
#--------------------------------------------------------
echo "========================================"
echo "Installing Wireshark..."
echo "========================================"
sudo apt -y install wireshark

# Ensure Wireshark requires sudo (disable non-root capture)
sudo dpkg-reconfigure wireshark-common

#--------------------------------------------------------
# 4. Create desktop icons
#--------------------------------------------------------
echo "========================================"
echo "Creating desktop icons..."
echo "========================================"

mkdir -p "$DESKTOP"

# VS Code
cat > "$DESKTOP/code.desktop" <<EOF
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
Exec=code
Icon=code
Terminal=false
Type=Application
Categories=Development;IDE;
EOF

# Firefox
cat > "$DESKTOP/firefox.desktop" <<EOF
[Desktop Entry]
Name=Firefox
Comment=Web Browser
Exec=firefox
Icon=firefox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF

# Wireshark (run with sudo)
cat > "$DESKTOP/wireshark.desktop" <<EOF
[Desktop Entry]
Name=Wireshark (sudo)
Comment=Network Protocol Analyzer
Exec=sudo wireshark
Icon=wireshark
Terminal=false
Type=Application
Categories=Network;Utility;
EOF

# Make desktop icons executable
chmod +x "$DESKTOP"/*.desktop

echo "========================================"
echo "Installation and desktop icons creation completed!"
echo "You can now launch VS Code, Firefox, and Wireshark from desktop."
echo "Wireshark requires sudo, so it will ask for your password when starting."
echo "========================================"
