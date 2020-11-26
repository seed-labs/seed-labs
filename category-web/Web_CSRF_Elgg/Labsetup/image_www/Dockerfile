FROM handsonsecurity/seed-elgg:csrf

# If the MySQL server's IP address is not 10.9.0.6, 
# you need to change the IP address in the setting file,
# and then uncomment the following COPY command
# COPY elgg-settings.php /var/www/elgg/elgg-config/settings.php

# Build the defense site
COPY defense /var/www/defense
COPY apache_defense.conf /etc/apache2/sites-available/
RUN  a2ensite apache_defense.conf   

