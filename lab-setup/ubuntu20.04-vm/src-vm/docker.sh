#!/bin/bash
  
# Install docker
sudo apt -y install docker.io

# Start docker and enable it to start after the system reboot:
sudo systemctl enable --now docker

# Optionally give any user administrative privileges to docker:
sudo usermod -aG docker seed


# Install docker-compose. Check whether 1.27.4 is the newest version
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
