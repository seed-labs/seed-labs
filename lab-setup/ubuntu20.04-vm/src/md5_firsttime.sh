#!/bin/bash

echo "Building md5collgen from source"
DOWNLOADS=/home/seed/Downloads/md5tool

mkdir $DOWNLOADS
wget -P $DOWNLOADS https://www.win.tue.nl/hashclash/fastcoll_v1.0.0.5-1_source.zip --no-check-certificate
unzip $DOWNLOADS/fastcoll_v1.0.0.5-1_source.zip -d $DOWNLOADS

cwd=$(pwd)
cd $DOWNLOADS

g++ -c md5.cpp
g++ -c block0.cpp
g++ -c block1.cpp
g++ -c block1stevens00.cpp
g++ -c block1stevens01.cpp
g++ -c block1stevens11.cpp
g++ -c block1stevens10.cpp
g++ -c block1wang.cpp
g++ -o md5collgen main.cpp -lboost_thread -lboost_serialization -lboost_program_options -lboost_filesystem -lboost_iostreams -lboost_system md5.o block0.o block1.o block1stevens00.o block1stevens01.o block1stevens10.o block1stevens11.o block1wang.o

# Installation
sudo cp md5collgen /usr/bin/

# Go back to the original folder
cd $cwd

# Cleanup
rm -rf $DOWNLOADS

