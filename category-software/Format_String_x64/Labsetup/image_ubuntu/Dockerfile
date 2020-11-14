FROM ubuntu:20.04

RUN  apt-get update  \
     && apt-get -y install \
        iputils-ping \
        net-tools \
        iproute2  \
        nano \
     && apt-get clean

COPY server_64 /
EXPOSE 9090

CMD [ "/bin/bash"]

