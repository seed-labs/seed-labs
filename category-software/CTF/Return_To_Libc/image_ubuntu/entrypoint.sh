#!/bin/bash

# The following several lines are to generate the buffer size used when compiling the vulnerable program
RANDOM=$(date +%N%s) # seed the RNG
MIN=10
MAX=800
DIFF=$(($MAX-$MIN+1))
BUFF_SIZE=$(($(($RANDOM%$DIFF))+$MIN)) # set BUFF_SIZE in range of [MIN, MAX]
while [[ $(($BUFF_SIZE%8)) -ne 0 && $BUFF_SIZE -lt $MAX ]]; # align BUFF_SIZE to be multiple of 8
do
   $((BUFF_SIZE++))
done

# compile and move the vulnerable program
gcc -m32 -DBUF_SIZE=$BUFF_SIZE -fno-stack-protector -z noexecstack -o /tmp/vuln /tmp/retlib.c
chown root /tmp/vuln
chmod 4755 /tmp/vuln
mv /tmp/vuln /usr/bin/
rm /tmp/*

ln -sf /bin/zsh /bin/sh # link shell that doesn't have Set-UID execution countermeasure

# start the SSH server, -D specifies run not as a daemon so that sshd will keep running in foreground to keep the Docker container alive
/usr/sbin/sshd -D 
