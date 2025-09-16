#!/bin/bash
set -e

# ==============================================
# 自动安装 Miniconda 并在 base 环境里安装常用库
# ==============================================

# 1. 下载 Miniconda 安装包
echo ">>> 下载 Miniconda 安装器..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

# 2. 安装 Miniconda 到 ~/miniconda3
echo ">>> 安装 Miniconda 到 ~/miniconda3..."
bash ~/miniconda.sh -b -p $HOME/miniconda3

# 3. 初始化 conda
echo ">>> 初始化 conda..."
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
conda init bash

# 4. 激活 base 环境
echo ">>> 激活 base 环境..."
conda activate base

# 5. 更新 conda
echo ">>> 更新 conda..."
conda update -n base -c defaults conda -y

# 6. 安装需要的软件包
echo ">>> 在 base 环境安装 scapy, jupyterlab, pycryptodome..."
conda install -y scapy jupyterlab pycryptodome

# 7. 清理安装包
rm ~/miniconda.sh

echo "===================================="
echo "✅ 安装完成！请重新打开终端以启用 conda。"
echo "   之后你可以运行 'jupyter lab' 来启动 JupyterLab"
echo "===================================="
