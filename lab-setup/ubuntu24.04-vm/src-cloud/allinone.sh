#!/bin/bash
set -e

USERID=seed
HOMEDIR="/home/$USERID"



echo "==> 创建 seed 用户..."
if ! id "$USERID" &>/dev/null; then
    sudo useradd -m -s /bin/bash "$USERID"
fi

echo "==> 配置 seed 用户免密码 sudo..."
echo "$USERID ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/90-seed
sudo chmod 440 /etc/sudoers.d/90-seed

echo "==> 更新 APT..."
sudo apt update -y
sudo apt upgrade -y

echo "==> 安装网络工具..."
sudo apt install -y telnet net-tools traceroute inetutils-inetd conntrack resolvconf

echo "==> 安装常用工具..."
# bless 和 ent 在 24.04 没有，用 ghex 替代 bless，ent 暂时去掉
sudo apt install -y execstack gcc-multilib gdb ghex libpcap-dev nasm unzip whois zip zsh firefox

echo "==> 安装 snap 并安装 VSCode..."
sudo apt install -y snapd
sudo snap install --classic code

git clone https://github.com/longld/peda.git /tmp/gdbpeda
sudo cp -r /tmp/gdbpeda /opt
rm -rf /tmp/gdbpeda


echo "==> 安装 Wireshark..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y wireshark
sudo groupadd -f wireshark
sudo usermod -aG wireshark "$USERID"
sudo usermod -aG wireshark "$USERID"

echo "==> 安装 XFCE4"
sudo DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-goodies lightdm



echo "***************************************"
echo "安装完成！seed 用户开机自动登录"
echo "***************************************"



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