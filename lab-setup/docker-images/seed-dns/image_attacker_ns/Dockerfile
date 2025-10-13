FROM handsonsecurity/seed-server24.04:bind

# Copy the configuration and zone files
COPY named.conf  zone_attacker32.com  zone_example.com  /etc/bind/

CMD ["named", "-g"]
