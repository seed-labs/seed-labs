FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

# install common tools + latest Python3 + pip
RUN apt-get update \
    && apt-get -y install \
        binutils \
        curl \
        iproute2 \
        iputils-ping \
        nano \
        net-tools \
        unzip \
        python3 \
        python3-pip \
        python3-setuptools \
    && rm -rf /var/lib/apt/lists/*

# Create seed user and set password
RUN useradd -m -s /bin/bash seed \
    && echo "root:dees" | chpasswd \
    && echo "seed:dees" | chpasswd

# Copy custom bashrc
COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc


# Default command to start bash
CMD ["/bin/bash"]
