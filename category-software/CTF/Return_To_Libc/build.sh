#!/bin/bash

ASLR=$(cat /proc/sys/kernel/randomize_va_space)
if [ $ASLR -ne 0 ]
then
   echo "Disabling Address Space Layout Randomization (ASLR) on the host so that it'll be disabled in the container..."
   sudo sysctl -w kernel.randomize_va_space=0
   ASLR=$(cat /proc/sys/kernel/randomize_va_space)
   if [ $ASLR -eq 0 ]
   then
      echo "ASLR has been disabled"
   else
      echo "ASLR was NOT disabled! Manually disable it via: 'sudo sysctl -w kernel.randomize_va_space=0'"
   fi
fi

sudo docker-compose build
