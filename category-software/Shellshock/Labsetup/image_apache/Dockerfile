FROM base-apache-php

COPY bash_shellshock /bin/
COPY vul.cgi getenv.cgi /usr/lib/cgi-bin/
COPY server_name.conf  /etc/apache2/sites-available
COPY start.sh /
RUN  chmod +x /start.sh \
     && chmod 755 /usr/lib/cgi-bin/*.cgi  \
     && a2ensite server_name.conf  \
     && rm -rf /var/lib/apt/lists/*


CMD [ "/start.sh"]


