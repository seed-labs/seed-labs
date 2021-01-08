FROM handsonsecurity/seed-ubuntu:small

# Copy the executable binaries to the image
COPY server padding_oracle_L1 padding_oracle_L2  /oracle/
WORKDIR /oracle

CMD ./server
