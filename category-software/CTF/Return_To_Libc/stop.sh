#!/bin/bash

sudo docker stop $(sudo docker ps -f name=return_to_libc_ -q)
