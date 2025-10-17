#!/bin/bash
set -e

echo "=== Update system ==="
sudo apt update
sudo apt -y upgrade

echo "=== Install Chinese language support ==="
sudo apt -y install language-pack-zh-hans
sudo locale-gen zh_CN.UTF-8

echo "=== Install ibus Chinese input method ==="
sudo apt -y install ibus ibus-pinyin ibus-libpinyin

echo "=== Enable IBus global autostart for all users ==="
sudo mkdir -p /etc/xdg/autostart
sudo tee /etc/xdg/autostart/ibus.desktop > /dev/null <<EOF
[Desktop Entry]
Type=Application
Exec=ibus-daemon -drx
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=IBus
Comment=Start IBus daemon
EOF


echo "=== Configure environment variables for IBus ==="
# Make sure ibus works in Xfce and VNC sessions
sudo tee /etc/profile.d/ibus.sh > /dev/null <<'EOF'
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
EOF

echo "=== All done! ==="
echo "📌 reboot machine, after first login, run: ibus-daemon -drx -> ibus-setup → Add → Chinese → intellgient Pinyin"
