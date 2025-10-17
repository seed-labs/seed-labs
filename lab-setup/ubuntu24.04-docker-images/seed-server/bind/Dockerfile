FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y install \
        binutils \
        curl \
        iproute2 \
        iputils-ping \
        nano \
        net-tools \
        dnsutils \
        tcpdump \
        bind9 \
        bind9-utils \
    && rm -rf /var/lib/apt/lists/*

# Run bind9 in foreground mode, output logs directly to docker logs
CMD ["/usr/sbin/named", "-f", "-g"]