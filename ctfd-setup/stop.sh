#!/bin/bash

sudo docker container stop $(sudo docker container ls -f name=ctfd_ -q)
