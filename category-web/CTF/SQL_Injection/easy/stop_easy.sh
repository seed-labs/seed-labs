#!/bin/bash
sudo docker stop $(sudo docker ps --filter name=ctf_sqli_mysql_easy --filter name=ctf_sqli_web_easy --quiet)
