FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

# 安装 Python 3.12 + pip + 常用工具
RUN apt-get update \
    && apt-get -y install \
        nano \
        python3 \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 安装 Flask（Ubuntu 24.04 pip 默认受限制，加上 --break-system-packages）
RUN pip3 install flask==1.1.1 --break-system-packages

CMD ["/bin/bash"]
