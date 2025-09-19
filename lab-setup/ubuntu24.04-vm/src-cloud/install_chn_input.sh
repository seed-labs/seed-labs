#!/bin/bash
set -e

echo "=== 更新系统 ==="
sudo apt update
sudo apt -y upgrade

echo "=== 安装中文语言支持 ==="
sudo apt -y install language-pack-zh-hans
sudo locale-gen zh_CN.UTF-8

echo "=== 安装 ibus 中文输入法 ==="
sudo apt -y install ibus ibus-pinyin ibus-libpinyin



# 配置 VNC xstartup
USERID=seed
HOMEDIR=/home/seed
mkdir -p $HOMEDIR/.vnc
cat > $HOMEDIR/.vnc/xstartup <<EOF
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export LANG=zh_CN.UTF-8
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
ibus-daemon -drx &
startxfce4 &
EOF
chmod +x $HOMEDIR/.vnc/xstartup
chown -R $USERID:$USERID $HOMEDIR/.vnc

echo "=== 设置 ibus 自启动 ==="
mkdir -p $HOMEDIR/.config/autostart
cat > $HOMEDIR/.config/autostart/ibus.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=ibus-daemon -drx
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=IBus
Comment=Start IBus daemon
EOF
chown -R $USERID:$USERID $HOMEDIR/.config

echo "=== 配置完成 ==="
echo "📌 请执行以下命令启动 VNC："
echo "   vncserver :1 -localhost no -geometry 1920x1080 -depth 24"
echo ""
# sudo ibus-daemon -drx
echo "📌 第一次进入桌面后，输入“运行 ibus-daemon -drx & ibus-setup” → 添加 → Chinese → Pinyin"
