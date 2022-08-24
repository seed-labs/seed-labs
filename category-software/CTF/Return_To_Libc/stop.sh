#!/bin/bash

if [ -n "$(sudo docker ps -f name=return_to_libc_ -q)" ]
then
   sudo docker stop $(sudo docker ps -f name=return_to_libc_ -q)
   echo ""
fi

echo "ENABLING ASLR..."
sudo sysctl -w kernel.randomize_va_space=2

ASLR=$(cat /proc/sys/kernel/randomize_va_space)

if [ $ASLR -ne 2 ]
then
   echo "  █████   ███   █████   █████████   ███████████   ██████   █████ █████ ██████   █████   █████████  ███"
   echo " ░░███   ░███  ░░███   ███░░░░░███ ░░███░░░░░███ ░░██████ ░░███ ░░███ ░░██████ ░░███   ███░░░░░███░███"
   echo "  ░███   ░███   ░███  ░███    ░███  ░███    ░███  ░███░███ ░███  ░███  ░███░███ ░███  ███     ░░░ ░███"
   echo "  ░███   ░███   ░███  ░███████████  ░██████████   ░███░░███░███  ░███  ░███░░███░███ ░███         ░███"
   echo "  ░░███  █████  ███   ░███░░░░░███  ░███░░░░░███  ░███ ░░██████  ░███  ░███ ░░██████ ░███    █████░███"
   echo "   ░░░█████░█████░    ░███    ░███  ░███    ░███  ░███  ░░█████  ░███  ░███  ░░█████ ░░███  ░░███ ░░░ "
   echo "     ░░███ ░░███      █████   █████ █████   █████ █████  ░░█████ █████ █████  ░░█████ ░░█████████  ███"
   echo "      ░░░   ░░░      ░░░░░   ░░░░░ ░░░░░   ░░░░░ ░░░░░    ░░░░░ ░░░░░ ░░░░░    ░░░░░   ░░░░░░░░░  ░░░ "
   echo ""
   echo "ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR) IS DISABLED ON THE HOST."
   echo "THIS IS A SERIOUS SECURITY VULNERABILITY THAT WILL PERSIST BEYOND RUNNING THIS CHALLENGE!"
   echo ""
   echo "Enable ASLR via 'sudo sysctl -w kernel.randomize_va_space=2'"
else
   echo "ASLR is enabled, your host system is safe again."
fi
