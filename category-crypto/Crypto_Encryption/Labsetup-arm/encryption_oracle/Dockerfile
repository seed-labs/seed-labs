FROM handsonsecurity/seed-ubuntu:dev-arm AS builder

# Copy the source code to the image
COPY .  /oracle
WORKDIR /oracle

RUN make


FROM handsonsecurity/seed-ubuntu:small-arm

# Copy the executable binaries to the image
COPY --from=builder /oracle/build /oracle
WORKDIR /oracle

CMD ./server
