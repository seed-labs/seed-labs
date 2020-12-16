#!/bin/bash

echo "Installing and configuring Apache ..."

# Install Apache2
sudo apt -y install apache2

# Install PHP and Apache-PHP module
sudo apt -y install php libapache2-mod-php


# Enable URL rewriting (for Elgg)
sudo a2enmod rewrite

# Enable SSL module (for PKI lab)
sudo a2enmod ssl

# Enable CGI module (for Shellshock lab)
sudo a2enmod cgi

# Restart Apache2
sudo service apache2 restart
