FROM python:3.8-slim-buster
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
          nano      \
    && rm -rf /var/lib/apt/lists/* 

RUN pip install flask==1.1.1

COPY app  /app
COPY bashrc /root/.bashrc
COPY start.sh /
RUN  chmod +x /start.sh

CMD [ "/start.sh"]
