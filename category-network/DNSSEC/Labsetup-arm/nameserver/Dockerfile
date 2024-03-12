FROM seed-base-image-bind

ARG BIND_CONF_DIR

# Copy the BIND configuration files
COPY named.conf named.conf.options  /etc/bind/
COPY ${BIND_CONF_DIR}     /etc/bind/

# Start the nameserver
CMD service named start  && tail -f /dev/null


