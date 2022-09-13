# Use Ubuntu v20.04 since that's what's used in the SEED Lab
FROM ubuntu:20.04

# Default arg values, most will be overwritten in docker-compose.yml
ARG PACKAGES="gcc-multilib xinetd netcat"
ARG DIFFICULTY="EASY"
ARG BUFFER_SIZE=100
ARG FLAG_IN_MEM="change_me"

# Docker documentation reccomends executing apt-get update and apt-get install in the same RUN command
RUN apt-get update && apt-get install -y ${PACKAGES} && rm -rf /var/lib/apt/lists/*

COPY xinetd.conf /etc/xinetd.conf
COPY format.c /ctf/format.c
COPY banner_success /ctf/banner_success
COPY banner_fail /ctf/banner_fail
COPY entry.sh /ctf/entry.sh
COPY flag.txt /root/flag.txt

# Wrap FLAG_IN_MEM in quotes so that the C macro will be assigned a string
RUN if [ $(echo "$DIFFICULTY" | tr [:lower:] [:upper:]) = "EASY" ]; then \
       gcc -static -m32 -z execstack -DBUF_SIZE=${BUFFER_SIZE} -DFLAG_IN_MEM=\"${FLAG_IN_MEM}\" /ctf/format.c -o /ctf/format && \
       rm /root/flag.txt; \
    elif [ $(echo "$DIFFICULTY" | tr [:lower:] [:upper:]) = "HARD" ]; then \
       gcc -static -m32 -z execstack -DBUF_SIZE=${BUFFER_SIZE} /ctf/format.c -o /ctf/format; \
    fi && \
    rm /ctf/format.c;

RUN chmod 0700 /ctf/entry.sh

EXPOSE 9999/tcp

# Check that xinetd is still serving up the vulnerable C program
HEALTHCHECK CMD echo "healthcheck" | nc -N localhost 9999

ENTRYPOINT ["/ctf/entry.sh"]

