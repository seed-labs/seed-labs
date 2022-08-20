#!/bin/bash
sudo docker-compose --file docker-compose_easy.yml up -d
sudo docker ps --filter name=ctf_sql
