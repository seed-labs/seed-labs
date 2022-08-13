FROM php:apache
ARG hard_mode

# Comment/uncomment the next two lines to set/unset production vs. development mode.
#RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN docker-php-ext-install mysqli
RUN apt update
RUN apt install -y ssl-cert
RUN a2enmod ssl
RUN a2ensite default-ssl.conf
COPY src/ /var/www/html/
RUN if [ $hard_mode = 1 ]; then \
       mv /var/www/html/add_hard.php /var/www/html/add.php; \
    else \
       rm /var/www/html/add_hard.php; \
    fi
WORKDIR /var/www/html
