#!/bin/bash
sudo docker-compose up -d
sudo docker ps --filter name=ctf_sql
