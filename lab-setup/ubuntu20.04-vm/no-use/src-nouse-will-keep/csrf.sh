#!/bin/bash 

echo "Installation for CSRF Attack Lab"
DOWNLOADS=/home/seed/Downloads/Elgg
ElggFile=Files/Elgg
FileDir=Files/CSRF
WWWDir=/var/www/CSRF/Elgg
DataDir=/var/elgg-data/CSRF

#-------------------------------------------------------
# Clean up first
sudo rm -rf /var/www/CSRF
sudo rm -rf $DataDir
sudo rm -f /etc/apache2/sites-available/csrf_elgg.conf
sudo rm -f /etc/apache2/sites-enabled/csrf_elgg.conf
sudo mysql -e "DROP DATABASE if exists elgg_csrf"


#------------------------------------------------------------
# Transforming Elgg to CSRF:Elgg
# Assumption: /var/www/CSRF/Elgg contains the original Elgg code
# Copy the elgg code to /var/www
#sudo mkdir -p /var/www/CSRF
#sudo cp -r /var/www/elgg-3.3.3  $WWWDir

# Download elgg-3.3.3 code
mkdir $DOWNLOADS
wget -P $DOWNLOADS https://elgg.org/about/getelgg?forward=elgg-3.3.3.zip --no-check-certificate
unzip $DOWNLOADS/'getelgg?forward=elgg-3.3.3.zip' -d $DOWNLOADS

# Copy the elgg code to /var/www
sudo mkdir -p /var/www/CSRF
sudo cp -r $DOWNLOADS/elgg-3.3.3  $WWWDir

# Clean up
rm -rf $DOWNLOADS


#------------------------------------------------------------
# Configure Elgg

# Create a data folder for elgg to upload files.
sudo mkdir -p $DataDir
sudo chown -R www-data $DataDir
sudo chgrp -R www-data $DataDir
sudo -u www-data unzip $ElggFile/elgg_data_1.zip -d $DataDir

# Create database
sudo mysql -e "CREATE DATABASE elgg_csrf"
sudo mysql -e "GRANT ALL PRIVILEGES ON elgg_csrf.* TO 'seed'@'localhost'"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql elgg_csrf < $ElggFile/elgg.sql


#------------------------------------------------------------
# Copy the setting and vulnerable code (disable CSRF countermeasures)
sudo cp $FileDir/settings.php $WWWDir/elgg-config/settings.php
sudo cp $FileDir/Csrf.php  $WWWDir/vendor/elgg/elgg/engine/classes/Elgg/Security/Csrf.php
sudo cp $FileDir/ajax.js   $WWWDir/vendor/elgg/elgg/views/default/core/js/ajax.js


#------------------------------------------------------------
# Creating web folder for Attacker
sudo mkdir /var/www/CSRF/Attacker
sudo chown seed /var/www/CSRF/Attacker
sudo chgrp seed /var/www/CSRF/Attacker

#------------------------------------------------------------
# Enable the CSRF sites
sudo cp $FileDir/csrf_elgg.conf  /etc/apache2/sites-available
sudo cp $FileDir/csrf_attacker.conf  /etc/apache2/sites-available
sudo a2ensite csrf_elgg.conf
sudo a2ensite csrf_attacker.conf
sudo service apache2 restart


# Cleanup
unset DOWNLOADS FileDir WWWDir DataDir ElggFile

