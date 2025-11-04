FROM handsonsecurity/seed-server:bind-arm

# Copy the configuration file for the local DNS server
COPY named.conf           /etc/bind/
COPY named.conf.options   /etc/bind/

CMD service named start && tail -f /dev/null 
