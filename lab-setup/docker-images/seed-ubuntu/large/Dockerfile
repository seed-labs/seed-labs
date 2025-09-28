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

# 安装基础工具 + PPA
RUN apt-get update \
    && apt-get install -y software-properties-common curl wget gnupg2 \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
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
        python3.8 \
        python3.8-venv \
        python3.8-dev \
        python3.8-distutils \
    && ln -sf /usr/bin/python3.8 /usr/bin/python3 \
    && rm -rf /var/lib/apt/lists/*

# 复制 get-pip 并安装 pip + scapy
COPY get-pip3.py /tmp
RUN python3 /tmp/get-pip3.py \
    && pip3 install scapy \
    && rm /tmp/get-pip3.py

# 创建用户 seed，设置密码
RUN useradd -m -s /bin/bash seed \
    && echo "root:dees" | chpasswd \
    && echo "seed:dees" | chpasswd

# 配置 bashrc
COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc

CMD ["/bin/bash"]
