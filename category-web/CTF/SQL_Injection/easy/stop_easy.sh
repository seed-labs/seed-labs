#!/bin/bash
sudo docker stop $(sudo docker ps -f name=ctf_sqli_ -q)
