#!/bin/bash

echo "--- Installing PHP7 and Apache 2.4 ---"
add-apt-repository -y ppa:ondrej/php-7.0
apt-get update
apt-get install -y apache2 php7.0 php7.0-dev php7.0-curl php7.0-opcache php7.0-json php7.0-mcrypt php7.0-pgsql php7.0-gd \
    libapache2-mod-php7.0 php7.0-sqlite php-xdebug
