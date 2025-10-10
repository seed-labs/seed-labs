FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

# 安装常用工具 + 最新 Python3 + pip
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

# 创建 seed 用户并设置密码
RUN useradd -m -s /bin/bash seed \
    && echo "root:dees" | chpasswd \
    && echo "seed:dees" | chpasswd

# 拷贝自定义 bashrc
COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc


# 默认启动 bash
CMD ["/bin/bash"]
