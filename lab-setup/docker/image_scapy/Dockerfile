FROM python:3.8-slim-buster
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
          arping \
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

# install scapy
RUN pip install scapy==2.4.3

# Create the "seed" user account
# Change seed's and root's passwords to "dees"
RUN  useradd -m -s /bin/bash seed \
     && echo "root:dees" | chpasswd \
     && echo "seed:dees" | chpasswd 
 
COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc

COPY start.sh /
RUN  chmod +x /start.sh

CMD [ "/start.sh"]

