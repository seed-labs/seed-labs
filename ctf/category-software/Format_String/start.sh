#!/bin/bash

disableASLR() {
   echo
   echo "DISABLING ASLR ON THE HOST..."

   # if ASLR is disabled on host, then it will be disabled in containers
   sudo sysctl -w kernel.randomize_va_space=0
   ASLR=$(cat /proc/sys/kernel/randomize_va_space)

   if [ $ASLR -eq 0 ]
   then
      echo
      echo "ASLR IS DISABLED!"
      return 0
   else
      echo
      echo "ASLR COULD NOT BE DISABLED."
      echo "MANUALLY DISABLE ASLR BEFORE RUNNING THIS SCRIPT AGAIN: '$ sudo sysctl -w kernel.randomize_va_space=0'"
      return 1
   fi

}

startContainers() {
   local CONTAINER=$1
   case "$CONTAINER" in
      easy_server)
         echo
         echo "STARTING CONTAINER 'easy_server'..."
         sudo docker-compose up -d easy_server
         ;;
      hard_server)
         echo
         echo "STARTING CONTAINER 'hard_server'..."
         sudo docker-compose up -d hard_server
         ;;
      *)
         echo
         echo "STARTING BOTH CONTAINERS..."
         sudo docker-compose up -d
         ;;
   esac
   return 0
}

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
            echo
            echo "PLEASE ANSWER YES OR NO!"
            ;;
      esac
   done
}

printHelp() {
   echo
   echo "Usage: start.sh [OPTION]"
   echo "Start the CTF Format String Docker application."
   echo
   echo "Options:"
   echo "   -h                               show this help dialogue"
   echo "   -c [easy_server | hard_server]   start one of the challenge containers"
   echo
   echo "Examples:"
   echo "   start.sh                  start all of the containers"
   echo "   start.sh -c easy_server   start just the container hosting the easy verion"
   echo "   start.sh -h               print the help dialogue"
}

while getopts 'hc:' OPTION; do
   case "$OPTION" in
      h)
         printHelp >&2
         exit 1
         ;;
      c)
         ARG=$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')
         if [[ "$ARG" == "easy_server" ]]; then
            CONTAINER=$ARG
         elif [[ "$ARG" == "hard_server" ]]; then
            CONTAINER=$ARG
         else
            echo
            echo "Usage: $(basename $0) -c [easy_server | hard_server]" >&2
            exit 1
         fi
         ;;
      ?)
         echo
         echo "Usage: $(basename $0) [-h] [-c container]" >&2
         exit 1
         ;;
   esac
done

printWarning

if getConsent -eq 0 ; then

   if disableASLR -eq 0 ; then

      startContainers $CONTAINER

      exit 0
   fi
fi

exit 1

