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

# Create the "seed" user account
# Change seed's and root's passwords to "dees"
RUN  useradd -m -s /bin/bash seed \
     && echo "root:dees" | chpasswd \
     && echo "seed:dees" | chpasswd


COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc

COPY start.sh /
RUN  chmod +x /start.sh \
     && rm -rf /var/lib/apt/lists/*

COPY resolv.conf /etc/resolv.conf.override

CMD [ "/start.sh"]

