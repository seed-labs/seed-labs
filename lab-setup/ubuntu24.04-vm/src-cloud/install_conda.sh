#!/bin/bash
USERID=seed


#====================================
echo "==================================="
echo "Updating apt ..."

sudo apt update
#====================================
echo "==================================="
echo "Installing Conda..."

wget -O ~/Anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
chmod +x ~/Anaconda.sh
bash ~/Anaconda.sh -b -p ~/anaconda3
source ~/anaconda3/bin/activate
conda init --all
