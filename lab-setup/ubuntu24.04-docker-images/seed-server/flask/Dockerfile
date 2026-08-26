FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

# install Python 3.12 + pip + common tools
RUN apt-get update \
    && apt-get -y install \
        nano \
        python3 \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Flask (Ubuntu 24.04 pip requires --break-system-packages flag due to system package protection)
RUN pip3 install flask==1.1.1 --break-system-packages

CMD ["/bin/bash"]
