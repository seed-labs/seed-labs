#!/bin/bash
sudo docker container stop $(sudo docker ps -f name=ctfd_ -q)
