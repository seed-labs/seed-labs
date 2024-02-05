FROM handsonsecurity/seed-ubuntu:small-arm

COPY server    /bof/

ARG LEVEL
COPY stack-${LEVEL}  /bof/stack

WORKDIR /bof

CMD ./server
