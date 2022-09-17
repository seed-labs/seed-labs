#!/bin/bash

checkASLR() {
   return $(cat /proc/sys/kernel/randomize_va_space)
}

disableASLR() {
   echo
   echo "ENABLING ASLR ON THE HOST..."

   sudo sysctl -w kernel.randomize_va_space=2
   
   checkASLR

   if [ $? -eq 2 ]
   then
      echo
      echo "ASLR IS ENABLED!"
      return 0
   else
      echo
      echo "ASLR FAILED TO ENABLE!"
      echo "MANUALLY ENABLE ASLR VIA '$ sudo sysctl -w kernel.randomize_va_space=2'"
      return 1
   fi
}

stopContainers() {
   local CONTAINER=$1
   case "$CONTAINER" in
      easy_server)
         echo
         echo "STOPPING CONTAINER 'easy_server'..."
         sudo docker-compose down easy_server
         ;;
      hard_server)
         echo
         echo "STOPPING CONTAINER 'hard_server'..."
         sudo docker-compose down hard_server
         ;;
      *)
         echo
         echo "STOPPING BOTH CONTAINERS..."
         sudo docker-compose down
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
   echo 
   echo "ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR) IS DISABLED ON THE HOST."
   echo "THIS IS A SERIOUS SECURITY VULNERABILITY THAT WILL PERSIST BEYOND RUNNING THIS CHALLENGE!"
   echo 
   echo "ENABLE ASLR VIA '$ sudo sysctl -w kernel.randomize_va_space=2'"

   return 0
}

getConsent() {
   while true; do
      read -p "DO YOU CONSENT TO ENABLING ASLR ON YOUR HOST? [Y|N] " yn
      case $yn in
         [Yy]* )
            return 0
            ;;
         [Nn]* )
            echo
            echo "IT IS STRONGLY RECOMMENDED TO ENABLE ASLR!"
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
   echo "Usage: stop.sh [OPTION]"
   echo "Stop the CTF Format String Docker application."
   echo
   echo "Options:"
   echo "   -h                               show this help dialogue"
   echo "   -c [easy_server | hard_server]   stop one of the challenge containers"
   echo
   echo "Examples:"
   echo "   stop.sh                  stop all of the containers"
   echo "   stop.sh -c easy_server   stop just the container hosting the easy verion"
   echo "   stop.sh -h               print the help dialogue"
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

if getConsent -eq 0 ; then
   
   disableASLR

fi

stopContainers $CONTAINER

checkASLR

if [ $? -eq 2 ]
then
   exit 0
else
   printWarning
   exit 1
fi

