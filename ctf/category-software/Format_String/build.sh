#!/bin/bash

BUILD_COMMAND="sudo docker-compose build --no-cache"

echo "Executing the build command '"$BUILD_COMMAND"'"
echo

eval $BUILD_COMMAND

