#!/bin/bash

disableASLR() {
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
      return 0
   else
      echo
      echo "ASLR COULD NOT BE DISABLED."
      echo "MANUALLY DISABLE ASLR BEFORE RUNNING THIS SCRIPT AGAIN: '$ sudo sysctl -w kernel.randomize_va_space=0'"
      return 1
   fi

}

startContainers() {
   local whichContainers=$1
   case "$whichContainers" in
      0)
         echo
         echo "STARTING CONTAINER 'easy_server'..."
         echo
         sudo docker-compose up -d easy_server
         ;;
      1)
         echo
         echo "STARTING CONTAINER 'hard_server'..."
         echo
         sudo docker-compose up -d hard_server
         ;;
      *)
         echo
         echo "STARTING BOTH CONTAINERS..."
         echo
         sudo docker-compose up -d
         ;;
   esac
   return 0
}

#disableAslrAndStart() {
#   echo
#   echo "DISABLING ASLR ON THE HOST..."
#   echo
#   
#   # if ASLR is disabled on host, then it will be disabled in containers
#   sudo sysctl -w kernel.randomize_va_space=0
#   ASLR=$(cat /proc/sys/kernel/randomize_va_space)
#   
#   if [ $ASLR -eq 0 ]
#   then
#      echo
#      echo "ASLR IS DISABLED!"
#      echo
#      echo "Starting up the containers..."
#      echo
#      sudo docker-compose up -d
#      echo
#      #sudo docker ps -f ancestor=easy_ctf_fmt_str_server
#   else
#      echo
#      echo "ASLR COULD NOT BE DISABLED."
#      echo "MANUALLY DISABLE ASLR BEFORE RUNNING THIS SCRIPT AGAIN: 'sudo sysctl -w kernel.randomize_va_space=0'"
#   fi
#}

printWarning() {
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
   echo
   return 0
}

getConsent() {
   while true; do
      read -p "DO YOU CONSENT TO DISABLING ASLR ON YOUR HOST? [Y|N] " yn
      case $yn in
         [Yy]* )
            return 0
            ;;
         [Nn]* )
            echo
            echo "ASLR MUST BE DISABLED ON THE HOST SO THAT IT WILL BE DISABLED IN THE CONTAINERS!"
            return 1
            ;;
         * )
            echo "PLEASE ANSWER YES OR NO!"
            ;;
      esac
   done
}

printWarning

if getConsent -eq 0 ; then
   if disableASLR -eq 0 ; then
      startContainers
   fi
fi

