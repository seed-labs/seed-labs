#!/bin/bash

ASLR=$(cat /proc/sys/kernel/randomize_va_space)

if [ "$ASLR" -ne 0 ];
then
   # if ASLR is not disabled in container we should return before doing more,
   # which will cause the container to die and indicate that there's
   # something wrong
   exit 1 # fail
fi

# See if port is open for TCP connection, 1 second timeout
nc -z -v -w 1 localhost 9999 &> /dev/null

CONN=$?

if [ "$CONN" != 0 ];
then
   exit 1 # fail
fi

exit 0 # success
