FROM ubuntu:16.04

RUN apt update 
RUN apt install --yes xinetd cowsay

RUN rm -rf /var/lib/apt/lists/*
RUN cp /usr/games/cowsay /bin/

RUN mkdir /ctf
WORKDIR /ctf
RUN useradd -M -d /ctf ctf

RUN chmod 600 /usr/bin/env

RUN echo "Connection blocked" > /etc/banner_fail
COPY ctf.xinetd /etc/xinetd.d/ctf
COPY flag.txt /ctf/
COPY script.sh /ctf/
COPY start.sh /ctf/

RUN chown -R root:ctf /ctf
RUN chmod -R 750 /ctf
RUN chmod 740 /ctf/flag.txt

ENTRYPOINT []
CMD ["/usr/sbin/xinetd", "-dontfork"]

EXPOSE 9999
