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

# 让 bind9 直接以前台模式运行
CMD ["/usr/sbin/named", "-f", "-g"]