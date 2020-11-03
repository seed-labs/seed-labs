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

# Create the "seed" user account
# Change seed's and root's passwords to "dees"
RUN  useradd -m -s /bin/bash seed \
     && echo "root:dees" | chpasswd \
     && echo "seed:dees" | chpasswd


COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc

COPY start.sh /
RUN  chmod +x /start.sh

COPY resolv.conf /etc/resolv.conf.override

CMD [ "/start.sh"]

