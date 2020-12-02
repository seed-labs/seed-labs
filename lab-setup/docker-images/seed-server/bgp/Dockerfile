FROM handsonsecurity/seed-ubuntu:small
ARG DEBIAN_FRONTEND=noninteractive

# Instrall the Bird server (for BGP)
RUN apt-get update && apt-get -y install bird

CMD mkdir -p /run/bird &&  bird -d

