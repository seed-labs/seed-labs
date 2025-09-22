#!/bin/bash

#=================================================================
# Most cloud platforms create a default account in the system.
# We will not use this account for SEED labs. Instead, we will
# create a new account called "seed", give it the privilege
# to run "sudo" commands. 
#=================================================================

#================================================
# Create a user account called "seed" if it does not exist. 
# For security, we will not set the password for this account, 
#   so nobody can ssh directly into this account. You need to 
#   set up public keys to ssh directly into this account.


# Interactive prompt
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
# Set the USERID shell variable.


sudo useradd -m -s /bin/bash seed 

# Allow seed to run sudo commands without password
sudo cp Files/System/seed_sudoers  /etc/sudoers.d/
sudo chmod 440 /etc/sudoers.d/seed_sudoers

echo "Set password for seed user account"
sudo passwd seed

USERID=seed

#================================================
echo "Installing various tools ..."

sudo apt update -y
#------------------------------------------------
# Networking Tools

sudo apt -y install telnetd
sudo apt -y install traceroute
sudo apt -y install openbsd-inetd
sudo apt -y install git

# net-tools include arp, ifconfig, netstat, route etc.
sudo apt -y install net-tools

# For Firewalls lab
sudo apt -y install conntrack

# For DNS
sudo apt -y install resolvconf




#------------------------------------------------
# Utilities

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




echo "==================================="
echo "Installing Docker Utilities..."
# Uninstall old versions
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Set up Docker's apt repository
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get -y install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start docker and enable it to start after the system reboot:
sudo systemctl enable --now docker

getent group docker || sudo groupadd docker

sudo gpasswd -a $USERID docker
# Install vscode 
# sudo snap install --classic code
echo "=== 安装 VSCode (deb 版) ==="
wget -qO /tmp/code.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
sudo dpkg -i /tmp/code.deb || sudo apt-get install -f -y
rm -f /tmp/code.deb


# sudo apt -y install vim  (already in the system)
# sudo apt -y install git  (already in the system)
# sudo apt -y install curl (already in the system)
# sudo apt -y install tcpdump (already in the system)

#================================================

# Python3.12 is already in the OS
# echo "Installing Python and modules ..."

# # Install pip3 and Python3 modules 
# sudo apt install -y pipx python3-venv python3-pip build-essential python3-scapy python3-pycryptodome
# # sudo apt install -y jupyter-notebook  ## old-version not suggest
# pipx ensurepath --global
# pipx install jupyterlab --global
# pipx install numpy    #for novnc

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



# sudo newgrp docker

if [ "$MODE" = "cloud" ]; then
    # Install browser
# sudo apt -y install firefox
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

    echo "========================================"
    echo "Installing XFCE4 Desktop Environment..."
    echo "You may be asked to choose a default display manager, please select LightDM."
    echo "========================================"

    sudo apt update
    sudo apt -y install xfce4 xfce4-goodies 

    echo "========================================"
    echo "Installing TigerVNC Server..."
    echo "========================================"

    sudo apt -y install tigervnc-standalone-server tigervnc-xorg-extension dbus-x11 xauth xterm


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
    # echo "=== 确保 LightDM 启动并设为默认 ==="
    # sudo systemctl enable lightdm
    # sudo systemctl set-default graphical.target

    echo "=== 给予 seed 用户图形权限 ==="
    sudo usermod -aG video,render,plugdev,cdrom,users seed
fi
#================================================
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

# Copy the desktop image files
sudo cp -f Files/System/Background/* /usr/share/backgrounds/xfce/

# Configure the VNC server 
sudo -u $USERID mkdir -p $HOMEDIR/.vnc
sudo -u $USERID cp Files/System/vnc_xstartup $HOMEDIR/.vnc/xstartup
sudo -u $USERID chmod u+x $HOMEDIR/.vnc/xstartup

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



# =====================================
# 安装 Miniconda 到公共目录 /opt/miniconda3
# 并为 seed 用户配置自动加载 conda 环境
# 在 base 环境安装 scapy 等工具
# =====================================

INSTALL_PREFIX="/opt/miniconda3"
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALL_SCRIPT="Miniconda3-latest-Linux-x86_64.sh"
SEED_USER="seed"
SEED_HOME="/home/$SEED_USER"

# 如果已经有安装目录就不再安装
if [ -d "$INSTALL_PREFIX" ]; then
    echo "✅ $INSTALL_PREFIX 已经存在，跳过安装步骤。"
else
    # 检查本地是否已有安装脚本
    if [ -f "$INSTALL_SCRIPT" ]; then
        echo "📦 检测到本地已有 $INSTALL_SCRIPT，跳过下载。"
    else
        echo "⬇️ 正在下载 Miniconda 安装脚本..."
        curl -LO "$MINICONDA_URL" || { echo "下载失败"; exit 1; }
    fi

    chmod +x "$INSTALL_SCRIPT"

    echo "🚀 正在以 root 安装 Miniconda 到 $INSTALL_PREFIX ..."
    sudo bash "$INSTALL_SCRIPT" -b -p "$INSTALL_PREFIX" || { echo "安装失败"; exit 1; }

    echo "✅ Miniconda 安装成功。"

    # 把 /opt/miniconda3/bin 加到所有用户 PATH
    echo 'export PATH="/opt/miniconda3/bin:$PATH"' | sudo tee /etc/profile.d/conda.sh >/dev/null
    sudo chmod +x /etc/profile.d/conda.sh

    # 给 sudo 组成员可读写
    sudo chgrp -R sudo "$INSTALL_PREFIX"
    sudo chmod -R g+rwX "$INSTALL_PREFIX"
    sudo find "$INSTALL_PREFIX" -type d -exec chmod g+s {} \;

    echo "✅ 已将 $INSTALL_PREFIX 权限设置为 sudo 组可读写"
fi

# 初始化 conda 到所有 shell
sudo -u $SEED_USER $INSTALL_PREFIX/bin/conda init bash zsh
# 接受 TOS
sudo "$INSTALL_PREFIX/bin/conda" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
sudo "$INSTALL_PREFIX/bin/conda" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# 禁止 conda 自动进入 base 环境
# sudo $INSTALL_PREFIX/bin/conda config --system --set auto_activate_base false

# 在 base 环境安装工具
echo "📦 在 base 环境安装 scapy ipython docker ..."
sudo $INSTALL_PREFIX/bin/conda install -n base -y scapy ipython jupyterlab pycryptodome
# docker 没有 conda 包，用 pip 安装
sudo $INSTALL_PREFIX/bin/pip install docker

# 如果公共环境不存在就创建
if [ ! -d "$INSTALL_PREFIX/envs/seedpy310" ]; then
    echo "📦 创建公共环境 seedpy310..."
    sudo $INSTALL_PREFIX/bin/conda create -p "$INSTALL_PREFIX/envs/seedpy310" python=3.10 -y
    echo "✅ 公共 Conda 环境 seedpy310 已创建"
else
    echo "✅ 公共环境 seedpy310 已存在，跳过创建。"
fi

# 给 seed 用户配置默认进入 seedpy310 环境
SEED_BASHRC="$SEED_HOME/.bashrc"
if ! grep -q "conda activate $INSTALL_PREFIX/envs/seedpy310" "$SEED_BASHRC"; then
    echo "source /opt/miniconda3/etc/profile.d/conda.sh" | sudo tee -a "$SEED_BASHRC" >/dev/null
    # echo "conda activate /opt/miniconda3/envs/seedpy310" | sudo tee -a "$SEED_BASHRC" >/dev/null
    sudo chown $SEED_USER:$SEED_USER "$SEED_BASHRC"
    echo "✅ 已配置 seed 用户自动进入 seedpy310 环境"
fi

echo "==================================="
echo "安装完成！"
echo "🔑 base 环境里已安装: scapy, ipython, docker(pip)"
# echo "🔑 seed 用户登录后会自动进入 seedpy310 环境"

