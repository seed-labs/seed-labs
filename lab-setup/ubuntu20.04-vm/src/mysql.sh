#!/bin/bash

echo "Installing MySQL"

#--------------------------------------------
# Install the MySQL server
sudo apt -y install mysql-server

# Create a new user called "seed" with password "dees@9DEES"
sudo mysql -e "CREATE USER 'seed'@'localhost' IDENTIFIED BY 'dees@9DEES';"

