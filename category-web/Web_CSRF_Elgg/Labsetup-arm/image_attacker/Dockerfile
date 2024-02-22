FROM handsonsecurity/seed-server:apache-php-arm

# Enable the attacker site
COPY apache_attacker.conf server_name.conf /etc/apache2/sites-available/
RUN  a2ensite server_name.conf   \
     && a2ensite apache_attacker.conf 


