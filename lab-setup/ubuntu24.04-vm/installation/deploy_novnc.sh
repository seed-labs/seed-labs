#!/bin/bash
# ==========================================================
# Auto deploy TigerVNC + noVNC on Ubuntu 24.04
# Usage:
#   sudo ./deploy_vnc.sh -p <password>
# ==========================================================

# ---------- Parse arguments ----------
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
  echo "❌ You must provide a VNC password using [-p]"
  exit 1
fi

USERID=seed
HOMEDIR=/home/$USERID

echo "=== 🚀 Starting TigerVNC + noVNC deployment ==="

# ---------- Install dependencies ----------
echo "=== 📦 Installing dependencies (if missing) ==="
sudo apt update -y
sudo apt install -y git xfce4 tigervnc-standalone-server python3 python3-websockify openssl

# ---------- Clone noVNC ----------
echo "=== 🌐 Cloning noVNC repository ==="
sudo mkdir -p /opt/noVNC
cd /opt/noVNC

# Clone repos quietly
sudo git clone https://github.com/novnc/noVNC.git . 


echo "✅ Successfully cloned noVNC"

# ---------- Permissions ----------
echo "=== 🔧 Setting permissions ==="
sudo chown -R root:root /opt/noVNC
sudo chmod -R a+rx /opt/noVNC


# ---------- Configure VNC password ----------
echo "=== 🔑 Setting VNC password for user [$USERID] ==="
sudo -u $USERID mkdir -p $HOMEDIR/.vnc
echo -e "$passwd\n$passwd\nn" | sudo -u $USERID vncpasswd >/dev/null 2>&1

# ---------- Write systemd units ----------
echo "=== ⚙️ Writing systemd service units ==="

# VNC Server
sudo tee /etc/systemd/system/vncserver.service > /dev/null << EOF
[Unit]
Description=TigerVNC Server for user $USERID
After=network.target

[Service]
Type=forking
User=$USERID
ExecStart=/usr/bin/tigervncserver :1 -localhost no -geometry 1920x1080 -depth 24 -xstartup /usr/bin/startxfce4
ExecStop=/usr/bin/tigervncserver -kill :1

[Install]
WantedBy=multi-user.target
EOF

# noVNC
sudo tee /etc/systemd/system/novnc.service > /dev/null << EOF
[Unit]
Description=noVNC WebSocket Proxy
After=network.target vncserver.service
Requires=vncserver.service

[Service]
User=$USERID
WorkingDirectory=/opt/noVNC
ExecStart=sudo /opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 6080
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# ---------- Start services ----------
echo "=== 🧩 Enabling and starting services ==="
sudo systemctl daemon-reload
sudo systemctl enable --now vncserver.service novnc.service
sleep 3

# ---------- Verify services ----------
echo "=== 🔍 Checking service status ==="
if systemctl is-active --quiet vncserver.service && systemctl is-active --quiet novnc.service; then
  echo "✅ TigerVNC + noVNC deployed successfully!"
  IP=$(hostname -I | awk '{print $1}')
  echo "🌐 Access URL: http://$IP:6080/vnc.html"
  echo "🔑 VNC password: $passwd"
  echo "🖥️  VNC desktop: $IP:5901 (Display :1)"
else
  echo "❌ Deployment failed. Check logs with:"
  echo "   sudo systemctl status vncserver novnc"
  exit 1
fi