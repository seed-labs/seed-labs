FROM handsonsecurity/seed-ubuntu:large-arm
ARG DEBIAN_FRONTEND=noninteractive

# Extra package needed by the Mitnick Attack Lab
RUN apt-get update \
    && apt-get -y install \
          rsh-redone-client \
          rsh-redone-server \
    && rm -rf /var/lib/apt/lists/*

