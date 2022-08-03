# Use Ubuntu v20.04 since that's what's used in the SEED Lab
FROM ubuntu:20.04

# Update packages, and install openssh-server to allow SSH connections to the container,
# and install gdb debugger for use when solving the challenge.
RUN apt update
RUN apt install openssh-server gdb vim -y

# Add the user account that students will use to SSH to the container.
RUN useradd --home-dir /home/seed --create-home --uid 1000 seed
RUN echo "seed:pass" | chpasswd

# Copy the sshd_config file to configure the SSH server running on the container,
# and then start the SSh service.
COPY sshd_config /etc/ssh/sshd_config
COPY ssh_banner /etc/ssh/ssh_banner
RUN service ssh start

# Launch the SSH server as a process, rather than a daemon so that the container will
# continue running.
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
