FROM base-apache-php

ARG DOWNLOAD=/tmp/download
ARG WWWDir=/var/www/elgg
ARG DataDir=/var/elgg-data

RUN mkdir -p $DOWNLOAD \
    && curl https://elgg.org/download/elgg-3.3.3.zip --output $DOWNLOAD/elgg-3.3.3.zip \
    && unzip $DOWNLOAD/elgg-3.3.3.zip -d /var/www/ \
    && mv /var/www/elgg-3.3.3 $WWWDir

COPY elgg/elgg_data.zip $DOWNLOAD
RUN mkdir -p $DataDir \
    && unzip $DOWNLOAD/elgg_data.zip -d $DataDir \
    && chown -R www-data $DataDir \
    && chgrp -R www-data $DataDir \
    && rm -rf $DOWNLOAD

COPY elgg/settings.php $WWWDir/elgg-config/settings.php
COPY elgg/Csrf.php     $WWWDir/vendor/elgg/elgg/engine/classes/Elgg/Security/Csrf.php
COPY elgg/ajax.js      $WWWDir/vendor/elgg/elgg/views/default/core/js/

# Enable the CSRF site
COPY apache_elgg_csrf.conf apache_defense.conf /etc/apache2/sites-available/
COPY server_name.conf  /etc/apache2/sites-available
COPY defense /var/www/defense
COPY start.sh /
RUN  chmod +x /start.sh \
     && a2ensite server_name.conf \
     && a2ensite apache_elgg_csrf.conf \
     && a2ensite apache_defense.conf   \
     && rm -rf /var/lib/apt/lists/*

CMD [ "/start.sh"]

