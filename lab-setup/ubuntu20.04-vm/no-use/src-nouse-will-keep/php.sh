#!/bin/bash

echo "Installing PHP and modules ..."
# Note: these Php extensions are needed by Elgg

sudo apt -y install php

sudo apt -y install libapache2-mod-php
sudo apt -y install php-gd php-pdo
sudo apt -y install php-json php-xml
sudo apt -y install php-mbstring
sudo apt -y install php-mysql
