FROM seed-apache-php

# Enable the attacker site
COPY apache_attacker.conf server_name.conf /etc/apache2/sites-available/
COPY start.sh /
RUN  chmod +x /start.sh \
     && a2ensite server_name.conf   \
     && a2ensite apache_attacker.conf \
     && rm -rf /var/lib/apt/lists/* 

CMD [ "/start.sh"]

