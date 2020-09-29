#!/bin/bash
  
echo "Cleaning up ..."

rm -f ~/.gdb_history
rm -f ~/.ssh/known_hosts
rm -f ~/.viminfo
rm -f ~/.python_history
rm -f ~/.mysql_history
rm -f ~/.wget-hsts
rm -rf ~/Downloads/*

cp /dev/null ~/.bash_history && history -cw

sudo cp /dev/null /var/log/apache2/access.log
sudo cp /dev/null /var/log/apache2/error.log
sudo cp /dev/null /var/log/apache2/other_vhosts_access.log

