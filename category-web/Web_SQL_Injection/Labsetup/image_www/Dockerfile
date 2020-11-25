FROM seed-apache-php

ARG WWWDir=/var/www/SQL_Injection

COPY Code $WWWDir
COPY sql_injection.conf  /etc/apache2/sites-available
COPY start.sh /
RUN  a2ensite sql_injection.conf \
     && chmod +x /start.sh

CMD [ "/start.sh"]


