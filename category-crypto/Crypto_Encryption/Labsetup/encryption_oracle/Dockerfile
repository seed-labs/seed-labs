FROM handsonsecurity/seed-ubuntu:dev AS builder

# Copy the source code to the image
COPY .  /oracle
WORKDIR /oracle

ARG secret
ENV SECRET=${secret}

RUN make



FROM handsonsecurity/seed-ubuntu:small

# Copy the executable binaries to the image
COPY --from=builder /oracle/build /oracle
WORKDIR /oracle

CMD ./server
