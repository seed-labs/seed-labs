FROM handsonsecurity/seed-ubuntu:dev

# Copy the source code to the image
COPY .  /oracle

WORKDIR /oracle

RUN make

CMD ./server
