#!/bin/bash

if [ -n "$(sudo docker ps -f ancestor=hard_ctf_fmt_str_server -q)" ]
then
   echo "STOPPING CONTAINERS..."
   echo
   sudo docker stop $(sudo docker ps -f ancestor=hard_ctf_fmt_str_server -q)
   echo 
fi

if [ -z "$(sudo docker ps --quiet --filter name=fmt_str)" ]
then
   echo "ENABLING ASLR..."
   echo
   sudo sysctl -w kernel.randomize_va_space=2
else
   echo
   echo "LEAVING ASLR DISABLED BECAUSE ANOTHER 'Format String' CTF IS STILL RUNNING..."
   echo
fi

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

