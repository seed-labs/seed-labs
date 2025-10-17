echo "=== 卸载 Docker 与 docker-compose ==="

# 停止 Docker 服务
sudo systemctl stop docker || true
sudo systemctl disable docker || true

# 卸载 docker.io 包
sudo apt-get purge -y docker.io

# 删除手动安装的 docker-compose
sudo rm -f /usr/local/bin/docker-compose

# 删除残留的数据和配置（容器、镜像、卷等都会清理）
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# 清理无用的依赖
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo "✅ Docker 和 docker-compose 已完全卸载"
