#!/bin/bash
sudo docker-compose --file docker-compose_difficult.yml up -d
sudo docker ps --filter name=ctf_sql
