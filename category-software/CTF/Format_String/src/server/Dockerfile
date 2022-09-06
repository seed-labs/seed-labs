# Use Ubuntu v20.04 since that's what's used in the SEED Lab
FROM ubuntu:20.04

ARG PACKAGES="gcc-multilib xinetd"
ARG BUFFER_SIZE

RUN apt --assume-yes update
RUN apt --assume-yes install $PACKAGES

COPY flag.txt /root/flag.txt
COPY xinetd.conf /etc/xinetd.conf
COPY format.c /ctf/format.c
COPY banner_success /ctf/banner_success
COPY banner_fail /ctf/banner_fail
COPY entry.sh /ctf/entry.sh

RUN gcc -static -m32 -z execstack -DBUF_SIZE=${BUFFER_SIZE} /ctf/format.c -o /ctf/format

RUN rm /ctf/format.c

RUN chmod 0700 /ctf/entry.sh

EXPOSE 7777/tcp

ENTRYPOINT ["/ctf/entry.sh"]

