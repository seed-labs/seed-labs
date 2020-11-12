FROM python:3.8-slim-buster
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
          iputils-ping \
          iproute2  \
          net-tools \
          dnsutils  \
          mtr-tiny  \
          nano      \
          telnet    \
          netcat    \
          tcpdump   \
    && rm -rf /var/lib/apt/lists/*

COPY bashrc /root/.bashrc
COPY start.sh /
RUN  chmod +x /start.sh

CMD ["/start.sh"]

