FROM handsonsecurity/seed-elgg:xss

# If the MySQL server's IP address is not 10.9.0.6, 
# you need to change the IP address in the setting file,
# and then uncomment the following COPY command
# COPY elgg-settings.php /var/www/elgg/elgg-config/settings.php

# Set up the CSP site (for one of the lab tasks) 
COPY csp /var/www/csp
COPY apache_csp.conf   /etc/apache2/sites-available
RUN  a2ensite apache_csp.conf  

