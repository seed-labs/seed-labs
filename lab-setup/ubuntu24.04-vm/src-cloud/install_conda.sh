#!/bin/bash
# =====================================
# 安装 Miniconda 到公共目录 /opt/miniconda3
# 允许 sudo 组成员读写
# =====================================

INSTALL_PREFIX="/opt/miniconda3"
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALL_SCRIPT="Miniconda3-latest-Linux-x86_64.sh"

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
sudo "$INSTALL_PREFIX/bin/conda" init --all

# 接受 TOS
sudo "$INSTALL_PREFIX/bin/conda" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
sudo "$INSTALL_PREFIX/bin/conda" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# 如果公共环境不存在就创建
if [ ! -d "$INSTALL_PREFIX/envs/seedpy310" ]; then
    echo "📦 创建公共环境 seedpy310..."
    sudo "$INSTALL_PREFIX/bin/conda" create -p "$INSTALL_PREFIX/envs/seedpy310" python=3.10 -y
    sudo "$INSTALL_PREFIX/bin/conda" install -p "$INSTALL_PREFIX/envs/seedpy310" -y scapy jupyterlab pycryptodome ipython
    echo "✅ 公共 Conda 环境 seedpy310 已创建"
else
    echo "✅ 公共环境 seedpy310 已存在，跳过创建。"
fi

echo "==================================="
echo "所有 sudo 组用户可使用以下命令进入环境："
echo "  conda activate /opt/miniconda3/envs/seedpy310"
