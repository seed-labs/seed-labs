#!/bin/bash

# if ASLR is disabled on host, then it will be disabled in containers
ASLR=$(cat /proc/sys/kernel/randomize_va_space)

if [ $ASLR -eq 0 ]
then
   echo "ASLR is disabled, starting up containers..." 
   sudo docker-compose up -d
   sudo docker ps -f name=return_to_libc_
else
   echo "Disabling Address Space Layout Randomization (ASLR) on the host so that it'll be disabled in the container..."
   sudo sysctl -w kernel.randomize_va_space=0
   ASLR=$(cat /proc/sys/kernel/randomize_va_space)
   if [ $ASLR -eq 0 ]
   then
      echo "ASLR is disabled, starting up containers..." 
      sudo docker-compose up -d
      sudo docker ps -f name=return_to_libc_
   else
      echo "ASLR was NOT disabled! Manually disable it before running containers: 'sudo sysctl -w kernel.randomize_va_space=0'"
   fi
fi

