#!/bin/bash

echo "Installing Crypto-related programs and files ..."

echo "Building md5collgen from source"
CRYPTODIR=Files/Crypto

# Install the Boost library
sudo apt -y install libboost-all-dev


#---------------------------------------------------------
# Installing md5collgen
# Note: For the first time, download and build md5collgen
source md5_firsttime.sh

# If we want to save time, we can directly copy the binary file
# sudo cp $CRYPTODIR/md5collgen /usr/bin/

