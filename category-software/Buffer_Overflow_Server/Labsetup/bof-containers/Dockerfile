FROM handsonsecurity/seed-ubuntu:small

COPY server    /bof/

ARG LEVEL
COPY stack-${LEVEL}  /bof/stack

WORKDIR /bof

CMD ./server
