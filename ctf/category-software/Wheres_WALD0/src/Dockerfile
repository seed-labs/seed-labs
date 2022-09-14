FROM ubuntu:16.04

RUN apt update 
RUN apt install --yes openssh-server
RUN mkdir /var/run/sshd

RUN mkdir /user1 
RUN mkdir /user2
RUN useradd -M -d /user1 user1
RUN useradd -M -d /user2 user2

RUN echo 'user1:find32' | chpasswd
RUN echo 'user2:AAE976A5232713355D58584CFE5A5' | chpasswd

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config

RUN chmod go-rx /usr/bin/passwd

COPY user1/* /user1/
COPY user2/* /user2/

RUN chown -R root:user1 /user1
RUN chown -R root:user2 /user2

RUN chmod -R 750 /user1
RUN chmod -R 750 /user2

RUN chmod 1733 /tmp /var/tmp /dev/shm

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
