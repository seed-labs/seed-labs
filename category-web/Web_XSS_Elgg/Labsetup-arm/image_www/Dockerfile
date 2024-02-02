FROM handsonsecurity/seed-elgg:original-arm

# The original Elgg is installed inside /var/www/elgg
ARG WWWDir=/var/www/elgg

# We customize the original Elgg program for the XSS lab.
# (1) disable the countermeasure and (2) set up the MySQL database.
# The following files are modified:
COPY elgg/settings.php $WWWDir/elgg-config/
COPY elgg/dropdown.php elgg/text.php elgg/url.php  $WWWDir/vendor/elgg/elgg/views/default/output/
COPY elgg/input.php    $WWWDir/vendor/elgg/elgg/engine/lib/
COPY elgg/ajax.js      $WWWDir/vendor/elgg/elgg/views/default/core/js/

# Enable the XSS site
COPY apache_elgg.conf /etc/apache2/sites-available/
RUN  a2ensite apache_elgg.conf


# Set up the CSP site (for one of the lab tasks) 
COPY csp /var/www/csp
COPY apache_csp.conf   /etc/apache2/sites-available
RUN  a2ensite apache_csp.conf  

