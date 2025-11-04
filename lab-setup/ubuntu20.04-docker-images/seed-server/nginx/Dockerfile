FROM handsonsecurity/seed-ubuntu:small
ARG DEBIAN_FRONTEND=noninteractive

# Instrall the nginx server 
RUN apt-get update && apt-get -y install nginx

CMD service nginx start && tail -f /dev/null

