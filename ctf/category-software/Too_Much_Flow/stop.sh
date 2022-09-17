#!/bin/bash
sudo docker stop $(sudo docker ps --quiet --filter ancestor=too-much-flow:latest)

