FROM handsonsecurity/seed-ubuntu:large
ARG DEBIAN_FRONTEND=noninteractive

COPY server /bof/server
COPY stack  /bof/stack
RUN chmod +x /bof/server
RUN chmod +x /bof/stack

