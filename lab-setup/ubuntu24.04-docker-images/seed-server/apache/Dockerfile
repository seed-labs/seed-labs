FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
        apache2 \
        nano   \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod cgi \
    && a2enmod headers

CMD ["apachectl", "-D", "FOREGROUND"]

