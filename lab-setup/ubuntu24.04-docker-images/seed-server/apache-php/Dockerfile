FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

# 安装基础工具和 PPA 管理工具
RUN apt-get update && apt-get install -y \
    software-properties-common \
    lsb-release \
    curl \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update

# 安装 Apache 和 PHP 7.4 及常用扩展
RUN apt-get install -y \
    apache2 \
    binutils \
    iproute2 \
    iputils-ping \
    nano \
    net-tools \
    unzip \
    libapache2-mod-php7.4 \
    php7.4-cli \
    php7.4-gd \
    php7.4-mysql \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-curl \
    php7.4-zip \
    php7.4-intl \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod cgi \
    && a2enmod headers \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 让 Apache 以前台模式运行，日志直接输出到 docker logs
CMD ["apache2ctl", "-D", "FOREGROUND"]
