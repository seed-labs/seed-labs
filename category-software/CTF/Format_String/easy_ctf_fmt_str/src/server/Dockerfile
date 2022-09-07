# Use Ubuntu v20.04 since that's what's used in the SEED Lab
FROM ubuntu:20.04

ARG PACKAGES="gcc-multilib xinetd"
ARG BUFFER_SIZE
ARG FLAG

# Docker documentation reccomends executing apt-get update and apt-get install in the same RUN command
RUN apt-get update && \
    apt-get install -y ${PACKAGES} && \
    rm -rf /var/lib/apt/lists/*

COPY xinetd.conf /etc/xinetd.conf
COPY format.c /ctf/format.c
COPY banner_success /ctf/banner_success
COPY banner_fail /ctf/banner_fail
COPY entry.sh /ctf/entry.sh

# Add quotes around FLAG so that it's passed in as a string to the c program
RUN gcc -static -m32 -z execstack -DBUF_SIZE=${BUFFER_SIZE} -DFLAG_IN_PROGRAM=\"${FLAG}\" /ctf/format.c -o /ctf/format && \
    rm /ctf/format.c

RUN chmod 0700 /ctf/entry.sh

EXPOSE 7777/tcp

ENTRYPOINT ["/ctf/entry.sh"]

