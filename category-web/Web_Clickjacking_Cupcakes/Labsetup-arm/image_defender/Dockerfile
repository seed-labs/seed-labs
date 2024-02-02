FROM handsonsecurity/seed-server:apache-arm

# Enable the defender site
COPY apache_defender.conf server_name.conf /etc/apache2/sites-available/
RUN  a2ensite server_name.conf   \
     && a2ensite apache_defender.conf 

