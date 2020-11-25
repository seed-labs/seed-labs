FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Ubuntu Layer 1
RUN apt-get update  \
    && apt-get -y install  \
        binutils \
        curl   \
        iproute2  \
        iputils-ping \
        nano   \
        net-tools \
        unzip

# Ubuntu Layer 2
RUN apt-get update  \
    && apt-get -y install  \
        arping \
        conntrack \
        curl   \
        dnsutils  \
        iptables \
        mtr-tiny  \
        netcat \
        openbsd-inetd  \
        procps \
        tcpdump   \
        telnet \
        telnetd 

# Install BIND 9
RUN apt-get update  \
    && apt-get -y install  \
          bind9  \
          bind9utils 

COPY named.conf           /etc/bind/
COPY named.conf.options   /etc/bind/

COPY bashrc /root/.bashrc
COPY start.sh /
RUN  chmod +x /start.sh \
     && rm -rf /var/lib/apt/lists/*

CMD [ "/start.sh"]
