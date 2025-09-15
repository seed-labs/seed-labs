#!/bin/bash

#====================================
# Create a user account called "seed"
sudo useradd -m -s /bin/bash seed

# Allow seed to run sudo commands without password
sudo cp Files/System/seed_sudoers /etc/sudoers.d
sudo chmod 440 /etc/sudoers.d/seed_sudoers
sudo su seed