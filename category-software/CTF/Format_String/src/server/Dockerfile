# Use Ubuntu v20.04 since that's what's used in the SEED Lab
FROM ubuntu:20.04

ARG PACKAGES="gcc-multilib xinetd"

RUN apt --assume-yes update
RUN apt --assume-yes install $PACKAGES

COPY flag.txt /root/flag.txt

COPY xinetd.conf /etc/xinetd.conf

COPY server.c /ctf/server.c

COPY banner_success /ctf/banner_success
COPY banner_fail /ctf/banner_fail

COPY entry.sh /ctf/entry.sh
RUN chmod 0700 /ctf/entry.sh
ENTRYPOINT ["/ctf/entry.sh"]

