FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
        apache2 \
        binutils \
        curl   \
        iputils-ping \
        iproute2  \
        nano   \
        net-tools \
        unzip  \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod cgi

COPY bash_shellshock /bin/
COPY vul.cgi getenv.cgi /usr/lib/cgi-bin/
COPY server_name.conf  /etc/apache2/sites-available
COPY start.sh /
RUN  chmod +x /start.sh \
     && chmod 755 /usr/lib/cgi-bin/*.cgi  \
     && a2ensite server_name.conf


CMD [ "/start.sh"]


