FROM handsonsecurity/seed-server:apache-php-arm

COPY bash_shellshock /bin/
COPY vul.cgi getenv.cgi /usr/lib/cgi-bin/
COPY server_name.conf  /etc/apache2/sites-available
RUN  chmod 755 /bin/bash_shellshock \
     && chmod 755 /usr/lib/cgi-bin/*.cgi  \
     && a2ensite server_name.conf  

CMD service apache2 start && tail -f /dev/null

