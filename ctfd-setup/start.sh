#!/bin/bash
sudo docker-compose --file ./CTFd/docker-compose.yml up -d
sudo docker ps --filter name=ctfd_
