#!/bin/bash
sudo docker-compose --file docker-compose_difficult.yml up -d
sudo docker ps --filter name=ctf_sqli_mysql_diff --filter name=ctf_sqli_web_diff
