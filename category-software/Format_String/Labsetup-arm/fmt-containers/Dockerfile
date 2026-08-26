FROM handsonsecurity/seed-ubuntu:small-arm
  
COPY server    /fmt/

ARG ARCH
COPY format-${ARCH}  /fmt/format

WORKDIR /fmt

CMD ./server
