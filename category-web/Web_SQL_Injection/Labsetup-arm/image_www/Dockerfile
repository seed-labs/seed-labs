FROM handsonsecurity/seed-server:apache-php-arm

COPY apache_sql_injection.conf  /etc/apache2/sites-available
RUN  a2ensite apache_sql_injection.conf 
