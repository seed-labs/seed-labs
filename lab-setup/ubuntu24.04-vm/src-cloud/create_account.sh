#!/bin/bash

#====================================
# Create a user account called "seed"
sudo useradd -m -s /bin/bash seed

# Allow seed to run sudo commands without password
sudo usermod -aG sudo seed

sudo passwd seed
sudo su seed