#!/bin/bash

echo "Installing openssl ..."
DOWNLOADS=/home/seed/Downloads/openssl

# Download the file
mkdir $DOWNLOADS
wget -P $DOWNLOADS https://www.openssl.org/source/openssl-1.1.1f.tar.gz --no-check-certificate

cwd=$(pwd)
cd $DOWNLOADS

# Untar the file and start building
tar -zxf openssl-1.1.1f.tar.gz 
cd openssl-1.1.1f
./config
make

# Doing testing (can be skipped; they all pass)
# make test 

# Install openssl (inside /usr/local)
sudo make install

# Create symbolic link from newly install binary to the default location:
sudo ln -sf /usr/local/bin/openssl /usr/bin/openssl

# Update symlinks and rebuild the library cache.
sudo ldconfig

# Testing (should display "OpenSSL 1.1.1f ...")
openssl version

# Go back to the original folder and clean up
cd $cwd
rm -rf $DOWNLOADS
