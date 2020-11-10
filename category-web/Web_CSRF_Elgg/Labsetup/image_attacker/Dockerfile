FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
        apache2 \
	libapache2-mod-php7.4 \
        php7.4-cli \
	php7.4-gd \
	php7.4-pdo \ 
	php7.4-json \
	php7.4-xml \
	php7.4-mbstring \
	php7.4-mysql \
        curl   \
        nano   \
        unzip  \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod cgi \
    && a2enmod headers


# Enable the attacker site
COPY apache_attacker.conf server_name.conf /etc/apache2/sites-available/
COPY start.sh /
RUN  chmod +x /start.sh \
     && a2ensite server_name.conf   \
     && a2ensite apache_attacker.conf 

CMD [ "/start.sh"]

