#!/usr/bin/env bash
# Ubuntu 24.04 一键安装 Jupyter Notebook（密码版，无 token）
set -e

USER_NAME=$(whoami)
VENV_DIR="$HOME/venv/jupyter"
JUPYTER_CONFIG_DIR="$HOME/.jupyter"
SERVICE_NAME="jupyter-notebook"
PORT=8888

# ===== 1. 设置你想用的明文密码 =====
PASS="seed2025"   # 改成你自己的密码
# ===================================

# 2. 更新系统
sudo apt update && sudo apt upgrade -y

# 3. 装基础依赖
sudo apt install -y python3-venv python3-pip build-essential

# 4. 建虚拟环境
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

# 5. 升级 pip 并安装 jupyter
pip install --upgrade pip
pip install notebook numpy pandas matplotlib scikit-learn scipy ipywidgets

# 6. 生成配置
mkdir -p "$JUPYTER_CONFIG_DIR"
jupyter notebook --generate-config -y

# 7. 计算密码哈希
HASH=$(python3 -c "from jupyter_server.auth import passwd; print(passwd('${PASS}'))")

# 8. 写入配置：禁用 token，启用密码
cat >> "$JUPYTER_CONFIG_DIR/jupyter_notebook_config.py" <<EOF
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = $PORT
c.ServerApp.open_browser = False
c.ServerApp.token = ''          # 空表示禁用 token
c.ServerApp.password = u'$HASH' # 使用刚才生成的哈希
EOF

# 9. 创建 systemd 用户服务
mkdir -p ~/.config/systemd/user/
cat > ~/.config/systemd/user/${SERVICE_NAME}.service <<EOF
[Unit]
Description=Jupyter Notebook
After=network.target

[Service]
Type=simple
User=$USER_NAME
ExecStart=$VENV_DIR/bin/jupyter notebook
Restart=on-failure
WorkingDirectory=$HOME

[Install]
WantedBy=default.target
EOF

# 10. 启动并设自启
systemctl --user daemon-reload
systemctl --user enable ${SERVICE_NAME}
systemctl --user start  ${SERVICE_NAME}

echo "=============================================="
echo "Jupyter 已安装并启动！"
echo "访问地址：http://$(hostname -I | awk '{print $1}'):$PORT"
echo "登录密码：${PASS}"
echo "状态  ：systemctl --user status ${SERVICE_NAME}"
echo "=============================================="