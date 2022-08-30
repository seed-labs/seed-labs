#!/bin/bash

gcc /ctf/server.c -o /ctf/server
rm /ctf/server.c

xinetd -dontfork
