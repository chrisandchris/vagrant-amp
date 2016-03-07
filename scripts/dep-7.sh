#!/bin/bash

echo "--- Installing PHP7 and Apache 2.4 ---"
add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get install -y apache2 php7.0 php7.0-dev php7.0-curl php7.0-opcache php7.0-json php7.0-mcrypt php7.0-pgsql php7.0-gd \
    libapache2-mod-php7.0 php7.0-sqlite php-mysql php-mbstring

sed -i "s/;date.timezone =/date.timezone = Europe\/Zurich/" /etc/php/7.0/apache2/php.ini
sed -i "s/;date.timezone =/date.timezone = Europe\/Zurich/" /etc/php/7.0/cli/php.ini

echo "--- Manually installing xdebug ---"
wget http://xdebug.org/files/xdebug-2.4.0.tgz /home/vagrant/xdebug-2.4.0.tgz
tar -xvzf xdebug-2.4.0.tgz
cd /home/vagrant/xdebug-2.4.0
phpize
./configure
make
cp modules/xdebug.so /usr/lib/php/20151012
echo "zend_extension = /usr/lib/php/20151012/xdebug.so" >> /etc/php/7.0/cli/php.ini
