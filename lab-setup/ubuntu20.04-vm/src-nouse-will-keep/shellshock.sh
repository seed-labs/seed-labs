#!/bin/bash

echo "Installing vulnerable bash shell ..."
DOWNLOADS=/home/seed/Downloads/Shell

#-------------------------------------------------------------
# Download and compile bash-4.2 for the Shellshock lab
mkdir $DOWNLOADS
wget -P $DOWNLOADS https://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz --no-check-certificate

cwd=$(pwd)
cd $DOWNLOADS

# Untar the file and start building
tar xzvf bash-4.2.tar.gz
cd bash-4.2
./configure
make

# Install it to /bin
sudo cp bash /bin/bash_shellshock

# Go back to the original folder and clean up
cd $cwd
rm -rf $DOWNLOADS
unset DOWNLOADS
