FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
          arping \
          bind9  \
          bind9utils \
          conntrack \
          curl   \
          dnsutils  \
          iputils-ping \
          iproute2  \
          iptables \
          mtr-tiny  \
          nano      \
          net-tools \
          netcat \
          openbsd-inetd  \
          procps \
          tcpdump   \
          telnet \
          telnetd \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update  \
    && apt-get -y install  \
          bind9  \
          bind9utils \
    && rm -rf /var/lib/apt/lists/*

COPY named.conf           /etc/bind/
COPY named.conf.options   /etc/bind/

COPY bashrc /root/.bashrc
COPY start.sh /
RUN  chmod +x /start.sh
CMD [ "/start.sh"]
