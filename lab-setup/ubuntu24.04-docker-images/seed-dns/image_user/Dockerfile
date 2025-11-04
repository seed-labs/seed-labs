FROM handsonsecurity/seed-ubuntu24.04:large

# We cannot directly set /etc/resolve.conf, because the file 
# will be overwritten when the container starts.
COPY resolv.conf /etc/resolv.conf.override

COPY start.sh /
RUN  chmod +x /start.sh 

# Copying to /etc/resolv.conf is done inside start.sh
CMD [ "/start.sh"]


