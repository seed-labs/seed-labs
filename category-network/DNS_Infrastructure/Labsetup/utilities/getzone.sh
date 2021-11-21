#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 Keyword Filename" >&2
  exit 1
fi

keyword=$1
filename=$2
filename_to=${keyword}_${filename}
containerID=$(docker ps | grep $keyword | awk '{print $1}')
if [[ ! -f $filename_to ]]; then
   docker cp $containerID:/etc/bind/zones/$filename ./$filename_to
else
   echo "** File $filename_to already exists; will not overwrite."
fi
