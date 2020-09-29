#!/bin/bash 

echo "Installing Elgg for the XSS Lab ..."
DOWNLOADS=/home/seed/Downloads/Elgg
ElggFile=Files/Elgg
FileDir=Files/XSS
WWWDir=/var/www/XSS/Elgg
DataDir=/var/elgg-data/XSS


#-------------------------------------------------------
# Clean up first
sudo rm -rf /var/www/XSS
sudo rm -rf $DataDir
sudo rm -f /etc/apache2/sites-available/xss_elgg.conf
sudo rm -f /etc/apache2/sites-enabled/xss_elgg.conf
sudo mysql -e "DROP DATABASE if exists elgg_xss"


#-------------------------------------------------------
# Download elgg-3.3.3 code 
mkdir $DOWNLOADS
wget -P $DOWNLOADS https://elgg.org/about/getelgg?forward=elgg-3.3.3.zip --no-check-certificate
unzip $DOWNLOADS/'getelgg?forward=elgg-3.3.3.zip' -d $DOWNLOADS

# Copy the elgg code to /var/www
sudo mkdir -p /var/www/XSS
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
sudo mysql -e "CREATE DATABASE elgg_xss"
sudo mysql -e "GRANT ALL PRIVILEGES ON elgg_xss.* TO 'seed'@'localhost'"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql elgg_xss < $ElggFile/elgg.sql


#------------------------------------------------------------
# Copy the setting and vulnerable code (disable XSS countermeasures)
sudo cp $FileDir/settings.php $WWWDir/elgg-config/settings.php
sudo cp $FileDir/dropdown.php $WWWDir/vendor/elgg/elgg/views/default/output/
sudo cp $FileDir/text.php     $WWWDir/vendor/elgg/elgg/views/default/output/
sudo cp $FileDir/url.php      $WWWDir/vendor/elgg/elgg/views/default/output/
sudo cp $FileDir/input.php    $WWWDir/vendor/elgg/elgg/engine/lib/

# Change the Add-Friend request from POST to GET (needed for the lab)
sudo cp $FileDir/ajax.js  $WWWDir/vendor/elgg/elgg/views/default/core/js/ajax.js


#------------------------------------------------------------
# Enable the XSS site
sudo cp $FileDir/xss_elgg.conf  /etc/apache2/sites-available
sudo a2ensite xss_elgg.conf
sudo service apache2 restart


# Cleanup
unset DOWNLOADS FileDir WWWDir DataDir ElggFile

