FROM handsonsecurity/seedemu-multiarch-base:buildx-latest
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get install -y --no-install-recommends python3.8-distutils

COPY server /bof/server
COPY stack  /bof/stack
RUN chmod +x /bof/server
RUN chmod +x /bof/stack
