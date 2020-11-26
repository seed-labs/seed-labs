FROM handsonsecurity/seed-server:apache-php

ARG WWWDir=/var/www/SQL_Injection

COPY Code $WWWDir
COPY sql_injection.conf  /etc/apache2/sites-available
RUN  a2ensite sql_injection.conf 



