#!/bin/bash 

echo "Installing Elgg ..."
DOWNLOADS=/home/seed/Downloads/Elgg
FileDir=Files/Elgg
WWWDir=/var/www/elgg-3.3.3
DataDir=/var/elgg-data/elgg-3.3.3

#------------------------------------------------------
# Install PHP and extensions required by Elgg
# These commands are moved to php.sh
#sudo apt -y install php 
#sudo apt -y install libapache2-mod-php
#sudo apt -y install php-gd php-pdo
#sudo apt -y install php-json php-xml
#sudo apt -y install php-mbstring


#-------------------------------------------------------
# Clean up first
sudo rm -rf $WWWDir
sudo rm -rf $DataDir
sudo rm -f /etc/apache2/sites-available/elgg_original.conf
sudo rm -f /etc/apache2/sites-enabled/elgg_original.conf
sudo mysql -e "DROP DATABASE if exists elgg_original"


#-------------------------------------------------------
# Download elgg-3.3.3 code 
mkdir $DOWNLOADS
wget -P $DOWNLOADS https://elgg.org/about/getelgg?forward=elgg-3.3.3.zip --no-check-certificate
unzip $DOWNLOADS/'getelgg?forward=elgg-3.3.3.zip' -d $DOWNLOADS

# Copy the elgg code to /var/www
sudo cp -r $DOWNLOADS/elgg-3.3.3  /var/www/

# Clean up
rm -rf $DOWNLOADS

#------------------------------------------------------------
# Configure Elgg

# Create a data folder for elgg to upload files.
sudo mkdir -p $DataDir
sudo chown -R www-data $DataDir
sudo chgrp -R www-data $DataDir

# Create database 
sudo mysql -e "CREATE DATABASE if not exists elgg_original"

# Assign privileges to user seed
sudo mysql -e "GRANT ALL PRIVILEGES ON elgg_original.* TO 'seed'@'localhost'"
sudo mysql -e "FLUSH PRIVILEGES;"

#------------------------------------------------------------
# Enable the XSS site
sudo cp $FileDir/elgg_original.conf  /etc/apache2/sites-available
sudo a2ensite elgg_original.conf
sudo service apache2 restart

#------------------------------------------------------------
# For the first time, follow the setup page in Elgg, using the following data:
# 1. Admin: name (Admin), userd (admin), email (elgg_admin@seed-labs.com), passwd (seedadmin)
# 2. Create five users, load the avatar 
# 3. Disable the Activity plug-in, so no activity is disabled 
#    Question: how to keep the plug-in, but clean all the activities? 
# 4. Question: how to remove the annoying messages "you have been logged int/out"?


#------------------------------------------------------------
# After we get all the setup files from the manual configuration, we can use the 
#   following scripts to automatically configure Elgg

# Resotre the avatar images
sudo -u www-data unzip $FileDir/elgg_data_1.zip -d $DataDir

# Restore the database 
sudo mysql -e "DROP DATABASE if exists elgg_original"
sudo mysql -e "CREATE DATABASE elgg_original"
sudo mysql -e "GRANT ALL PRIVILEGES ON elgg_original.* TO 'seed'@'localhost'"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql elgg_original < $FileDir/elgg.sql

# Restore the settings
sudo cp $FileDir/settings.php $WWWDir/elgg-config

# Change the Add-Friend request from POST to GET (needed for the lab)
sudo cp $FileDir/ajax.js  $WWWDir/vendor/elgg/elgg/views/default/core/js/ajax.js

# Cleanup
unset DOWNLOADS FileDir WWWDir DataDir

