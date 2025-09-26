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
#         python3.8 \
#         python3-distutils \
#      && rm -rf /var/lib/apt/lists/*


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

# 安装依赖 + 添加 deadsnakes 源
RUN apt-get update && apt-get install -y \
    software-properties-common \
    binutils \
    curl \
    iproute2 \
    iputils-ping \
    nano \
    net-tools \
    unzip \
 && add-apt-repository ppa:deadsnakes/ppa -y \
 && apt-get update && apt-get install -y \
    python3.8 \
    python3.8-distutils \
 && rm -rf /var/lib/apt/lists/*

# 创建 seed 用户并设置密码
RUN useradd -m -s /bin/bash seed \
    && echo "root:dees" | chpasswd \
    && echo "seed:dees" | chpasswd

# 复制 bashrc
COPY bashrc /home/seed/.bashrc
COPY bashrc /root/.bashrc

# 默认启动 bash
CMD ["/bin/bash"]
