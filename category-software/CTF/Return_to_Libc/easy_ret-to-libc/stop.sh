#!/bin/bash

if [ -n "$(sudo docker ps -f name=easy_ret-to-libc -q)" ]
then
   echo "STOPPING CONTAINERS..."
   echo
   sudo docker stop $(sudo docker ps -f name=easy_ret-to-libc -q)
   echo 
fi

echo "ENABLING ASLR..."
echo
sudo sysctl -w kernel.randomize_va_space=2

ASLR=$(cat /proc/sys/kernel/randomize_va_space)

if [ $ASLR -ne 2 ]
then
   echo
   echo "  █████   ███   █████   █████████   ███████████   ██████   █████ █████ ██████   █████   █████████  ███"
   echo " ░░███   ░███  ░░███   ███░░░░░███ ░░███░░░░░███ ░░██████ ░░███ ░░███ ░░██████ ░░███   ███░░░░░███░███"
   echo "  ░███   ░███   ░███  ░███    ░███  ░███    ░███  ░███░███ ░███  ░███  ░███░███ ░███  ███     ░░░ ░███"
   echo "  ░███   ░███   ░███  ░███████████  ░██████████   ░███░░███░███  ░███  ░███░░███░███ ░███         ░███"
   echo "  ░░███  █████  ███   ░███░░░░░███  ░███░░░░░███  ░███ ░░██████  ░███  ░███ ░░██████ ░███    █████░███"
   echo "   ░░░█████░█████░    ░███    ░███  ░███    ░███  ░███  ░░█████  ░███  ░███  ░░█████ ░░███  ░░███ ░░░ "
   echo "     ░░███ ░░███      █████   █████ █████   █████ █████  ░░█████ █████ █████  ░░█████ ░░█████████  ███"
   echo "      ░░░   ░░░      ░░░░░   ░░░░░ ░░░░░   ░░░░░ ░░░░░    ░░░░░ ░░░░░ ░░░░░    ░░░░░   ░░░░░░░░░  ░░░ "
   echo 
   echo "ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR) IS DISABLED ON THE HOST."
   echo "THIS IS A SERIOUS SECURITY VULNERABILITY THAT WILL PERSIST BEYOND RUNNING THIS CHALLENGE!"
   echo 
   echo "ENABLE ASLR VIA 'sudo sysctl -w kernel.randomize_va_space=2'"
else
   echo
   echo "ASLR IS ENABLED, YOUR HOST SYSTEM IS SAFE AGAIN!"
fi

