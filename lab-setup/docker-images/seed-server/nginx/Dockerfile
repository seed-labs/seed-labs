FROM handsonsecurity/seed-ubuntu24.04:small
ARG DEBIAN_FRONTEND=noninteractive

# Instrall the nginx server 
RUN apt-get update && apt-get -y install nginx

CMD ["bash", "-c", "service nginx start && tail -f /dev/null"]

