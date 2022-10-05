#!/bin/bash

# if ASLR is disabled on host, then it will be disabled in containers
ASLR=$(cat /proc/sys/kernel/randomize_va_space)

if [ "$ASLR" -ne 0 ];
then
   # if ASLR is not disabled in container we should return before doing more,
   # which will cause the container to die and indicate that there's
   # something wrong
   exit 1
fi

# Tells xinetd to stay in the foreground rather than detaching itself, so that Docker container will stay alive.
xinetd -dontfork

