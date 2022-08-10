# Use Ubuntu v20.04 since that's what's used in the SEED Lab
FROM ubuntu:20.04

ARG VULN_PROG_BUF_SIZE
ARG DEBIAN_FRONTEND=noninteractive
ARG VULN_PROG_NAME=retlib
ARG EXEC_NAME=runme
ARG SEED_USER_PASS

# Needed to get pass interactive prompts when installing build-essential
ENV TZ=America/Chicago

# Update packages, and install openssh-server to allow SSH connections to the container,
# and install gdb debugger for use when solving the challenge.
RUN apt update
RUN apt install openssh-server gdb vim build-essential gcc-multilib --assume-yes

# Add the user account that students will use to SSH to the container.
RUN useradd --home-dir /home/seed --create-home --uid 1000 seed
RUN echo "seed:$SEED_USER_PASS" | chpasswd

# Copy the sshd_config file to configure the SSH server running on the container,
# and then start the SSh service.
COPY sshd_config /etc/ssh/sshd_config
COPY ssh_banner /etc/ssh/ssh_banner
RUN service ssh start

COPY ${VULN_PROG_NAME}.c /tmp/
RUN gcc -m32 -DBUF_SIZE=$VULN_PROG_BUF_SIZE -fno-stack-protector -z noexecstack -o /tmp/$EXEC_NAME /tmp/${VULN_PROG_NAME}.c
RUN chown root /tmp/$EXEC_NAME
RUN chmod 4755 /tmp/$EXEC_NAME

# Launch the SSH server as a process, rather than a daemon so that the container will
# continue running.
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
