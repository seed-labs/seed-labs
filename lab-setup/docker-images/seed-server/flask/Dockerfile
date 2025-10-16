FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
        nano \
        python3.8-distutils \
     && rm -rf /var/lib/apt/lists/*

COPY get-pip3.py /tmp

RUN  python3 /tmp/get-pip3.py \
     && pip3 install flask==1.1.1 \
     && rm /tmp/get-pip3.py

CMD /bin/bash

