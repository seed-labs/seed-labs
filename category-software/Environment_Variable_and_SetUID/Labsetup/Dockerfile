FROM ubuntu:latest

# General
RUN useradd -ms /bin/bash seed && \
    echo "seed:seed" | chpasswd && \
    adduser seed sudo
RUN yes | unminimize && \  
    apt update && \
    apt full-upgrade
RUN apt install -y \ 
        sudo \
        man \
        nano \
        vim

# Lab specific
RUN apt install -y \         
        gcc

USER seed
WORKDIR /home/seed

COPY . /home/seed