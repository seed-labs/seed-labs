#!/usr/bin/env bash
set -e
USERID=seed

#====================================
echo "==================================="
echo "Installing Docker Utilities..."
# Uninstall old versions
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg || true; done

# Set up Docker's apt repository
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings

# Try downloading GPG key, retry on failure
echo "Downloading Docker GPG key..."
GPG_KEY="/etc/apt/keyrings/docker.asc"
for i in {1..3}; do
    if sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o "$GPG_KEY"; then
        echo "GPG key downloaded successfully."
        break
    else
        echo "Curl failed (attempt $i), retrying in 5 seconds..."
        sleep 5
    fi
done

# If still failed, switch to USTC mirror
if [ ! -s "$GPG_KEY" ]; then
    echo "Switching to USTC mirror for GPG key..."
    sudo curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg -o "$GPG_KEY"
fi
sudo chmod a+r "$GPG_KEY"

# Add the repository to Apt sources:
CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
ARCH=$(dpkg --print-architecture)
REPO_URL="https://download.docker.com/linux/ubuntu"

# Detect China network and use mirror
if ping -c 1 -W 1 mirrors.ustc.edu.cn >/dev/null 2>&1; then
    echo "Detected China network, using USTC mirror..."
    REPO_URL="https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu"
fi

echo \
  "deb [arch=${ARCH} signed-by=${GPG_KEY}] ${REPO_URL} \
  ${CODENAME} stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start docker and enable it to start after the system reboot:
sudo systemctl enable --now docker

sudo groupadd -f docker

# sudo gpasswd -a $USERID docker
sudo usermod -aG docker $USERID

# sudo newgrp docker

echo "==================================="
echo "Docker installation completed successfully."
echo "You can verify installation using: docker version"
echo "==================================="


