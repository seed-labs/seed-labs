#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 Keyword Filename" >&2
  exit 1
fi

keyword=$1
filename=$2
filename_from=${keyword}_${filename}
containerID=$(docker ps | grep $keyword | awk '{print $1}')
if [[ -f $filename_from ]]; then
   echo "== Copy zone file to container"
   docker cp ./$filename_from $containerID:/etc/bind/zones/$filename 

   echo "== Restart the nameserver"
   docker exec $containerID service named restart
else
   echo "** File $filename_from does not exists."
fi
