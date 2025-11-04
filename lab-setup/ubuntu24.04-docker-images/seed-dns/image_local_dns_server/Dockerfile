FROM handsonsecurity/seed-server24.04:bind

# Copy the configuration file for the local DNS server
COPY named.conf           /etc/bind/
COPY named.conf.options   /etc/bind/

CMD ["named", "-g"]
