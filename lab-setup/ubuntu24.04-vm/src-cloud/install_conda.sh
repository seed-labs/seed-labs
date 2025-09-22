
#!/bin/bash
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
