#!/bin/bash

RANDOM=$(date %s%N) # seed random

buf=$[ $RANDOM % 800 + 100] # generate random number between 100 and 800

gcc -static -m32 -z execstack -DBUF_SIZE=${buf} /ctf/format.c -o /ctf/format

rm /ctf/format.c

xinetd -dontfork
