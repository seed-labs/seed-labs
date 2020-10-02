#!/bin/bash
# NB: run script with sudo

apt update
apt -y upgrade

# Install xrdp for serving GUI over RDP 
apt install -y xrdp
adduser xrdp ssl-cert
[ -f /etc/xrdp/xrdp.ini ] && \
{ grep -qxF 'address=0.0.0.0' /etc/xrdp/xrdp.ini || sed -ie "/^#background=.*/a address=0.0.0.0" /etc/xrdp/xrdp.ini; }

# Use non-default RDP port of 5901 (remember to connect with <IP>:5901)
[ -f /etc/xrdp/xrdp.ini ] && \
sed -ie "s/^port=3389/port=5901/" /etc/xrdp/xrdp.ini

# Replace default Wireshark for compatibility with xfce4
apt remove -y wireshark-common
apt install -y wireshark-gtk

# Set Wireshark to be runnable by non-root user
#groupadd wireshark
# NB: dpkg-reconfigure will pop up interactive window
dpkg-reconfigure wireshark-common 
chgrp wireshark /usr/bin/dumpcap
usermod -a -G wireshark seed
chmod 754 /usr/bin/dumpcap

# Install xfce4 as Desktop Manager
apt install -y xfce4 \
               xfce4-terminal \
               xfce4-goodies \
               gnome-icon-theme-full \
               tango-icon-theme

# Configure for xfce4
echo "xfce4-session" > /home/seed/.xsession
[ -f /home/seed/.xsession ] && chmod 644 /home/seed/.xsession
[ -f /etc/xrdp/startwm.sh ] && \
sed -ie "s/^\(\. \)\(.*session.*\)/#\1\2\nstartxfce4/" /etc/xrdp/startwm.sh

# Update path (already correct in SSH access but not xrdp access for
# some reason)
[ -f /home/seed/.bashrc ] && \
sed -ie "s/^\(export PATH=\)\(\$PATH:\$ANDROID_HOME.*\)/\1\/home\/seed\/bin:\/sbin:\2/" \
/home/seed/.bashrc

# Reset default seed password
echo -e "5sFr7%93#PJY\n5sFr7%93#PJY" | passwd seed

# Force password reset upon first login
passwd -e seed

# Make changes to xrdp effective
# NOTE: xrdp may have to be manually restarted
# from SSH access to image before remote login works (even if "sudo
# systemctl status xrdp" says xrdp is running).
service xrdp restart

# NOTE: Additional non-scripted changes done to baseline image include:

# Fix no-tab-autocomplete in terminal bug.
# 1. Open Application Menu > Settings > Window Manager.
# 2. Click on 'Keyboard' tab.
# 3. Clear the 'Switch window for same application' setting.
# Credits: instructions from:
# https://askubuntu.com/questions/545540/terminal-autocomplete-doesnt-work-properly
#          bug confirmation:
# https://www.starnet.com/xwin32kb/tab-key-not-working-when-using-xfce-desktop/

# Remove the toolbar icon for Wireshark and create new one that's
# a shortcut to wireshark-gtk .

