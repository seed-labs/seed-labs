#!/bin/bash

echo "Installation for the SQL Injection Attack Lab"
FileDir=Files/SQL_Injection
WWWDir=/var/www/SQL_Injection


#-------------------------------------------------------
# Clean up first
sudo rm -rf $WWWDir
sudo a2dissite sql_injection.conf
sudo rm -f /etc/apache2/sites-available/sql_injection.conf
sudo mysql -e "DROP DATABASE if exists sqllab_users"


#------------------------------------------------------------
# Create and import the database, grant privileges to seed
sudo mysql -e "CREATE DATABASE if not exists sqllab_users"
sudo mysql -e "GRANT ALL PRIVILEGES ON sqllab_users.* TO 'seed'@'localhost'"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql sqllab_users < $FileDir/sqllab_users.sql

# Copy the web application files to /var/www
sudo mkdir $WWWDir 
sudo cp -r $FileDir/Code/* $WWWDir


#------------------------------------------------------------
# Enable the SQL Injection site
sudo cp $FileDir/sql_injection.conf  /etc/apache2/sites-available
sudo a2ensite sql_injection.conf
sudo service apache2 restart

#------------------------------------------------------------
unset WWWDir FileDir
