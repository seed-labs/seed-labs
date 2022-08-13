# Use Ubuntu v20.04 since that's what's used in the SEED Lab
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Specifed in docker-compose.yml
ARG SEED_USER_PASS

# Needed to get pass interactive prompts when installing build-essential
ENV TZ=America/Chicago

# Update packages, and install openssh-server to allow SSH connections to the container,
# and install gdb debugger for use when solving the challenge.
RUN apt update
RUN apt install openssh-server gdb vim build-essential gcc-multilib python3 zsh --assume-yes

# Add the user account that students will use to SSH to the container.
RUN useradd --home-dir /home/seed --create-home --uid 1000 seed
RUN echo "seed:$SEED_USER_PASS" | chpasswd
RUN chage -d 0 seed # force seed account to change password on first login

# Copy the sshd_config file to configure the SSH server running on the container,
# and then start the SSH service.
COPY sshd_config /etc/ssh/sshd_config
COPY ssh_banner /etc/ssh/ssh_banner
RUN service ssh start

# Copy the vulnerable program to the container
COPY retlib.c /tmp/retlib.c

# Copy the flag to the container and set permissions
COPY flag.txt /root/.flag.txt
RUN chown root /root/.flag.txt
RUN chmod 0500 /root/.flag.txt

# This file is needed to run the vulnerable program
COPY the_file /home/seed/the_file
RUN chown seed /home/seed/the_file
RUN chmod 0500 /home/seed/the_file

# Copy the entrypoint script to the container, and give execution privileges
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
