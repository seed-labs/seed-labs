FROM seed-base-image-bind
  
# Copy the BIND configuration files
COPY named.conf named.conf.options bind.keys  /etc/bind/

# Copy the Root Hints
COPY root.hints  /usr/share/dns/

# Start the nameserver
CMD service named start  && tail -f /dev/null

