MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
# 定义安装脚本的文件名
INSTALL_SCRIPT="Miniconda3-latest-Linux-x86_64.sh"
# 检查Conda是否已经安装
if command -v conda &> /dev/null; then
    echo "Conda 已经安装，跳过安装步骤。"
else
    if [ -f "$INSTALL_SCRIPT" ]; then
        echo "Miniconda安装脚本已存在，将直接进行安装。"
    else
        # 下载Miniconda安装脚本
        echo "正在下载Miniconda安装脚本..."
        curl -LO "$MINICONDA_URL"

        # 检查下载是否成功
        if [ $? -ne 0 ]; then
            echo "下载失败，请检查链接的合法性或网络连接。"
            exit 1
        fi
    fi

    # 给安装脚本添加可执行权限
    chmod +x "$INSTALL_SCRIPT"

    # 自动安装Miniconda
    echo "正在安装Miniconda..."
    bash "$INSTALL_SCRIPT" -u -b -p $HOME/miniconda3

    # 检查安装是否成功
    if [ $? -eq 0 ]; then
        echo "Miniconda安装成功。"
    else
        echo "Miniconda安装失败。"
        exit 1
    fi

    # 初始化Miniconda
    echo "初始化Miniconda..."
    source $HOME/miniconda3/bin/activate

    # 验证安装
    echo "验证Miniconda安装..."
    conda --version

    # 完成
    echo "Miniconda安装完成。"

    # 自动将Conda添加到环境变量
    # echo "将Conda添加到环境变量..."

    # if [ -f "$HOME/.bashrc" ]; then
    #     # echo "export PATH=\"$HOME/miniconda3/bin:\$PATH\"" >> $HOME/.bashrc
    #     echo "source $HOME/miniconda3/bin/activate" >> $HOME/.bashrc
    #     # echo "Conda已添加到环境变量。"
    # else
    #     echo "未找到 .bashrc 文件，请手动将以下内容添加到你的shell配置文件中："
    #     echo "export PATH=\"$HOME/miniconda3/bin:\$PATH\""
    #     echo "source $HOME/miniconda3/bin/activate"
    # fi
    # 初始化Miniconda
    # echo "初始化Miniconda..."
    # source $HOME/miniconda3/bin/activate

    # 重新加载 .bashrc 文件
    echo "重新加载 .bashrc 文件以使更改生效..."
    source $HOME/.bashrc

    # 验证环境变量是否生效
    echo "验证环境变量是否生效..."
    conda --version
fi
#!/bin/bash
conda init
# 关闭自动激活base虚拟环境
echo "关闭自动激活base虚拟环境"
conda config --set auto_activate_base false

# 创建虚拟环境
echo "创建虚拟环境 ctf..."
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

echo "==================================="
echo "Creating Virtual Environment..."
conda create -n seedpy310 python=3.10 -y
conda activate seedpy310
conda install -y scapy jupyterlab pycryptodome ipython
