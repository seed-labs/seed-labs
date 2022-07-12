FROM php:apache
#RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN docker-php-ext-install mysqli
RUN apt update
RUN apt install -y ssl-cert
RUN a2enmod ssl
RUN a2ensite default-ssl.conf
COPY src/ /var/www/html/
WORKDIR /var/www/html
