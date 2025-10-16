#!/bin/bash

# 使用方法： ./deploy_vnc.sh -p 密码
# ------------------------------------------------

# 解析参数
passwd=""
while getopts "p:" opt; do
  case $opt in
    p)
      passwd=$OPTARG
      ;;
    \?)
      echo "Usage: $0 [-p password]"
      exit 1
      ;;
  esac
done

if [ -z "$passwd" ]; then
  echo "必须提供 VNC 密码 [-p]"
  exit 1
fi

USERID=seed
HOMEDIR=/home/$USERID

echo "=== 开始部署 noVNC 和 TigerVNC ==="

# -------------------------------
# 安装 noVNC/websockify 到 /opt
# -------------------------------
sudo mkdir -p /opt/noVNC
sudo cp -r Files/VNC/noVNC/* /opt/noVNC/
sudo cp -r Files/VNC/websockify /opt/noVNC/utils/

# 修改权限：root 拥有，但任何用户可读执行
sudo chown -R root:root /opt/noVNC
sudo chmod -R a+rx /opt/noVNC

# 生成自签名证书
sudo openssl req -new -x509 -days 365 -nodes \
  -out /opt/noVNC/self.pem \
  -keyout /opt/noVNC/self.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/OU=OrganizationalUnit/CN=localhost"

# -------------------------------
# 配置 seed 用户的 VNC 密码
# -------------------------------
echo -e "$passwd\n$passwd\nn" | sudo -u $USERID vncpasswd

# -------------------------------
# 写 vncserver systemd 单元
# -------------------------------
sudo tee /etc/systemd/system/vncserver.service > /dev/null << EOF
[Unit]
Description=Systemd VNC server startup script for Ubuntu 24.04
After=syslog.target network.target

[Service]
Type=forking
User=$USERID
ExecStart=/usr/bin/tigervncserver :1 -localhost no -geometry 1920x1080 -depth 24 -xstartup /usr/bin/startxfce4
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF

# -------------------------------
# 写 noVNC systemd 单元
# -------------------------------
sudo tee /etc/systemd/system/novnc.service > /dev/null << EOF
[Unit]
Description=Systemd noVNC for Ubuntu 24.04
After=network.target vncserver.service

[Service]
User=$USERID
WorkingDirectory=/opt/noVNC
ExecStart=/usr/bin/python3 /opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 6080

[Install]
WantedBy=multi-user.target
EOF

# -------------------------------
# 重载并启动服务
# -------------------------------
sudo systemctl daemon-reload
sudo systemctl enable --now vncserver.service novnc.service
sleep 2
sudo systemctl restart vncserver.service novnc.service

# -------------------------------
# 检查服务状态
# -------------------------------
if systemctl is-active --quiet vncserver.service && systemctl is-active --quiet novnc.service; then
    echo "✅ 部署成功"
else
    echo "❌ 部署失败，请用 'systemctl status vncserver novnc' 查看日志"
    exit 1
fi
