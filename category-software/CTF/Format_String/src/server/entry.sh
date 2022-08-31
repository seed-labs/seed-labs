#!/bin/bash

RANDOM=$(date +%s%N) # seed random

MAX=800
MIN=100
SIZE=$(( $RANDOM % $MAX + $MIN )) # generate random number between MIN and MAX 

while [[ $(( $SIZE % 8 )) -ne 0 && $SIZE -lt $MAX ]]
do
   ((SIZE++))
done

gcc -static -m32 -z execstack -DBUF_SIZE=${SIZE} /ctf/format.c -o /ctf/format

rm /ctf/format.c

xinetd -dontfork # Tells xinetd to stay in the foreground rather than detaching itself, so that Docker container will stay alive.
