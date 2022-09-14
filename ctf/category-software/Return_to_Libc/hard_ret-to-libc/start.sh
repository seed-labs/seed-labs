#!/bin/bash

disableAslrAndStart() {
   echo
   echo "DISABLING ASLR ON THE HOST..."
   echo
   
   # if ASLR is disabled on host, then it will be disabled in containers
   sudo sysctl -w kernel.randomize_va_space=0
   ASLR=$(cat /proc/sys/kernel/randomize_va_space)
   
   if [ $ASLR -eq 0 ]
   then
      echo
      echo "ASLR IS DISABLED!"
      echo
      echo "Starting up the containers..."
      echo
      sudo docker-compose up -d
      echo
      sudo docker ps -f name=hard_ret-to-libc
   else
      echo
      echo "ASLR COULD NOT BE DISABLED."
      echo "MANUALLY DISABLE ASLR BEFORE RUNNING THIS SCRIPT AGAIN: 'sudo sysctl -w kernel.randomize_va_space=0'"
   fi
}

echo
echo "  █████   ███   █████   █████████   ███████████   ██████   █████ █████ ██████   █████   █████████  ███"
echo " ░░███   ░███  ░░███   ███░░░░░███ ░░███░░░░░███ ░░██████ ░░███ ░░███ ░░██████ ░░███   ███░░░░░███░███"
echo "  ░███   ░███   ░███  ░███    ░███  ░███    ░███  ░███░███ ░███  ░███  ░███░███ ░███  ███     ░░░ ░███"
echo "  ░███   ░███   ░███  ░███████████  ░██████████   ░███░░███░███  ░███  ░███░░███░███ ░███         ░███"
echo "  ░░███  █████  ███   ░███░░░░░███  ░███░░░░░███  ░███ ░░██████  ░███  ░███ ░░██████ ░███    █████░███"
echo "   ░░░█████░█████░    ░███    ░███  ░███    ░███  ░███  ░░█████  ░███  ░███  ░░█████ ░░███  ░░███ ░░░ "
echo "     ░░███ ░░███      █████   █████ █████   █████ █████  ░░█████ █████ █████  ░░█████ ░░█████████  ███"
echo "      ░░░   ░░░      ░░░░░   ░░░░░ ░░░░░   ░░░░░ ░░░░░    ░░░░░ ░░░░░ ░░░░░    ░░░░░   ░░░░░░░░░  ░░░ "
echo ""
echo "ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR) MUST BE DISABLED ON THE HOST SO THAT IT'LL BE DISABLED IN THE CONTAINERS."
echo "THIS IS A SERIOUS SECURITY VULNERABILITY THAT WILL PERSIST BEYOND RUNNING THIS CHALLENGE!"
echo "YOUR HOST SYSTEM WILL BE MADE VULNERABLE IN ORDER TO RUN THIS CHALLENGE."
while true; do
   read -p "DO YOU CONSENT TO DISABLING ASLR ON YOUR HOST? [Y|N] " yn
   case $yn in
      [Yy]* )
         disableAslrAndStart
         break
         ;;
      [Nn]* )
         echo "ASLR MUST BE DISABLED ON THE HOST SO THAT IT WILL BE DISABLED IN THE CONTAINERS!"
         exit
         ;;
      * )
         echo "Please answer yes or no!"
         ;;
   esac
done

