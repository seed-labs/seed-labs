#!/bin/bash

# We can use this program to build the multi-arch image 
# for all the docker images used in the SEED labs.

PREFIX="seed-labs/lab-setup/docker-images/"

dockerfile_dirs=(
  "seed-ubuntu/small"
  "seed-ubuntu/large"
  "seed-ubuntu/medium"
  "seed-ubuntu/dev"
  "seed-server/apache"
  "seed-server/apache-php"
  "seed-server/bgp"
  "seed-server/bind"
  "seed-server/flask"
  "seed-server/ngix"
  "seed-elgg/original"
)

for name in "${dockerfile_dirs[@]}"; do
   directory_name=$(dirname "$PREFIX$name")

   image_name="handsonsecurity/$(basename "$directory_name"):$(basename "$name")"

   echo $image_name

   sudo docker buildx build --push \
               --platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
	       --tag "$image_name" "$dir"

   if [ $? -eq 0 ]; then
     echo "Successfully built image: $image_name"
   else
     echo "Failed to build image: $image_name"
   fi
done

