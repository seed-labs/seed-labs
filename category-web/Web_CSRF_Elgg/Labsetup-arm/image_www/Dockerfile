FROM handsonsecurity/seed-elgg:original-arm

# The original Elgg is installed inside /var/www/elgg
ARG WWWDir=/var/www/elgg

# The original Elgg is customized for the CSRF lab to
# disable the countermeasure and to set up the MySQL database.
# The following files are modified:
COPY elgg/settings.php $WWWDir/elgg-config/settings.php
COPY elgg/Csrf.php     $WWWDir/vendor/elgg/elgg/engine/classes/Elgg/Security/Csrf.php
COPY elgg/ajax.js      $WWWDir/vendor/elgg/elgg/views/default/core/js/


# Build the Elgg site
COPY apache_elgg.conf /etc/apache2/sites-available/
RUN  a2ensite apache_elgg.conf

# Build the defense site
COPY defense /var/www/defense
COPY apache_defense.conf /etc/apache2/sites-available/
RUN  a2ensite apache_defense.conf   

