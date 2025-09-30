FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update  \
    && apt-get -y install  \
        apache2 \
        binutils \
        curl   \
        iproute2  \
        iputils-ping \
        nano   \
        net-tools \
        unzip \
        # PHP 8.3 (24.04 默认版本)
        libapache2-mod-php8.3 \
        php8.3-cli \
        php8.3-gd \
        php8.3-mysql \
        php8.3-xml \
        php8.3-mbstring \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod cgi \
    && a2enmod headers

# 让 Apache 以前台模式运行，日志直接输出到 docker logs
CMD ["apachectl", "-D", "FOREGROUND"]
