FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

# install common tools + Python3 + pip
RUN apt-get update \
    && apt-get -y install \
        binutils \
        curl \
        iproute2 \
        iputils-ping \
        nano \
        net-tools \
        unzip \
        arping \
        conntrack \
        dnsutils \
        iptables \
        mtr-tiny \
        netcat-openbsd \
        openbsd-inetd \
        procps \
        tcpdump \
        telnet \
        telnetd \
        python3 \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install scapy (Ubuntu 24.04 pip requires --break-system-packages flag due to system package protection)
RUN pip3 install scapy --break-system-packages

# Create seed user and set password
RUN useradd -m -s /bin/bash seed \
    && echo "root:dees" | chpasswd \
    && echo "seed:dees" | chpasswd

# Copy custom bashrc
COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc


CMD ["/bin/bash"]
