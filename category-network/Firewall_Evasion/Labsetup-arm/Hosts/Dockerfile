FROM handsonsecurity/seed-ubuntu:large-arm
ARG DEBIAN_FRONTEND=noninteractive

# Extra package needed by the Mitnick Attack Lab
RUN apt-get update \
    && apt-get -y install openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install PySocks

COPY sshd_config /etc/ssh/sshd_config
