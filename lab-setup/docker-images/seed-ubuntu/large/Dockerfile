# FROM ubuntu:20.04
# ARG DEBIAN_FRONTEND=noninteractive

# RUN apt-get update  \
#     && apt-get -y install  \
#         binutils \
#         curl   \
#         iproute2  \
#         iputils-ping \
#         nano   \
#         net-tools \
#         unzip \
#         # 
#         arping \
#         conntrack \
#         curl   \
#         dnsutils  \
#         iptables \
#         mtr-tiny  \
#         netcat \
#         openbsd-inetd  \
#         procps \
#         tcpdump   \
#         telnet \
#         telnetd \
#         python3.8-distutils \
#      && rm -rf /var/lib/apt/lists/*

# COPY get-pip3.py /tmp

# RUN  python3 /tmp/get-pip3.py \
#      && pip3 install scapy \
#      && rm /tmp/get-pip3.py

# # Create the "seed" user account
# # Change seed's and root's passwords to "dees"
# RUN  useradd -m -s /bin/bash seed \
#      && echo "root:dees" | chpasswd \
#      && echo "seed:dees" | chpasswd

# COPY bashrc /home/seed/.bashrc
# COPY bashrc /root/.bashrc

# CMD /bin/bash

FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

# 安装常用工具 + Python3 + pip
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

# 安装 scapy（Ubuntu 24.04 pip 需加 --break-system-packages）
RUN pip3 install scapy --break-system-packages

# 创建 seed 用户并设置密码
RUN useradd -m -s /bin/bash seed \
    && echo "root:dees" | chpasswd \
    && echo "seed:dees" | chpasswd

# 拷贝自定义 bashrc
COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc


CMD ["/bin/bash"]
