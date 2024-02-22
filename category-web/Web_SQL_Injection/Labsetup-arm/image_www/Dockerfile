FROM handsonsecurity/seed-server:apache-php-arm

ARG WWWDir=/var/www/SQL_Injection

COPY Code $WWWDir
COPY apache_sql_injection.conf  /etc/apache2/sites-available
RUN  a2ensite apache_sql_injection.conf 



