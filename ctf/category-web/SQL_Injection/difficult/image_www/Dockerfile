FROM php:apache

# Comment/uncomment the next two lines to set/unset production vs. development mode.
#RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN docker-php-ext-install mysqli

RUN apt update
RUN apt install -y ssl-cert

RUN a2enmod ssl
RUN a2ensite default-ssl.conf

COPY src_difficult/* /var/www/html/

WORKDIR /var/www/html
