#!/bin/bash

# 初始化变量
passwd=""

# 使用 getopts 解析选项
while getopts "p:" opt; do
  case $opt in
    p)
      passwd=$OPTARG
      ;;
    \?)
      exit 1
	  echo "Usage: $0 [-p 123]"
      ;;
  esac
done

# 检查是否提供了密码
if [ -z "$passwd" ]; then
  echo "必须提供密码 [-p]"
  exit 1
fi

USERID=seed
HOMEDIR=/home/$USERID

echo "开始部署 ..."
cp -r Files/VNC/noVNC -d $HOMEDIR/ && cp -r Files/VNC/websockify -d $HOMEDIR/noVNC/utils/ && cd $HOMEDIR/noVNC && openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem -subj "/C=US/ST=State/L=City/O=Organization/OU=OrganizationalUnit/CN=localhost"
# 检查是否成功
if [ $? -eq 0 ]; then
    echo "部署 noVNC 成功\n"
else
    echo "部署 noVNC 失败\n"
	exit 1
fi

sleep 3
echo -e "$passwd\n$passwd\nn" | vncpasswd


echo "配置 vncservcer 服务..."
sudo bash -c 'cat > /etc/systemd/system/vncserver@.service << EOF
[Unit]
Description=Systemd VNC server startup script for Ubuntu 24.04
After=syslog.target network.target

[Service]
Type=forking
User=seed
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1920x1080 :%i -localhost no
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF'

echo "配置 novnc 服务..."
sudo bash -c 'cat > /etc/systemd/system/novnc.service << EOF
[Unit]
Description=Systemd noVNC for Ubuntu 24.04
After=syslog.target network.target

[Service]
User=seed
ExecStart=/home/seed/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 8443

[Install]
WantedBy=multi-user.target
EOF'

# 重载服务、设置开启自启并立即启动，启动后可能服务并没有立即生效，等待2s后再重新服务，确保服务正常启动
sudo systemctl daemon-reload && sudo systemctl enable --now novnc vncserver@1 && sleep 2 && sudo systemctl restart novnc vncserver@1

# 检查是否成功
if [ $? -eq 0 ]; then
    echo "部署成功\n"
else
    echo "部署失败\n"
	exit 1
fi