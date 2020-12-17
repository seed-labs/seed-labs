FROM handsonsecurity/seed-ubuntu:small

# Copy the Flask app to the image
COPY .  /oracle

WORKDIR /oracle

RUN apt-get update && apt-get install -y build-essential libssl-dev && apt-get clean && make

CMD ./server
