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
        gcc \
        gcc-multilib \
        make \
        netcat \
        python3

USER seed
WORKDIR /home/seed

COPY /server-code /home/seed
COPY /attack-code /home/seed