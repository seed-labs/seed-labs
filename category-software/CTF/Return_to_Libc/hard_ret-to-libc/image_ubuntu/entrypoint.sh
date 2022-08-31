#!/bin/sh

# if ASLR is disabled on host, then it will be disabled in containers
ASLR=$(cat /proc/sys/kernel/randomize_va_space)

if [ $ASLR -ne 0 ];
then
   # if ASLR is not disabled in container we should return before doing more,
   # which will cause the container to die and indicate that there's
   # something wrong
   return 1
fi

# The following several lines are to generate the buffer size used when compiling the vulnerable program
RANDOM=$(date +%N%s) # seed the RNG
MIN=100
MAX=800
DIFF=$(($MAX-$MIN+1))
BUFF_SIZE=$(($(($RANDOM%$DIFF))+$MIN)) # set BUFF_SIZE in range of [MIN, MAX]
while [ $BUFF_SIZE -lt $MAX ]; # align BUFF_SIZE to be multiple of 8
do
   if [ $(( $BUFF_SIZE % 8)) -eq 0 ];
   then
      break
   else
      $((BUFF_SIZE++))
   fi
done

# compile and move the vulnerable program
gcc -m32 -DBUF_SIZE=$BUFF_SIZE -fno-stack-protector -z noexecstack -o /usr/bin/vuln /tmp/retlib.c
chown root /usr/bin/vuln
chmod 4755 /usr/bin/vuln
rm /tmp/*

ln -sf /bin/zsh /bin/sh # link shell that doesn't have Set-UID execution countermeasure

# start the SSH server, -D specifies run not as a daemon so that sshd will keep running in foreground to keep the Docker container alive
/usr/sbin/sshd -D 
