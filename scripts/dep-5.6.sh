#!/usr/bin/env bash

echo "--- Installing PHP5.6 and Apache 2.4 ---"
add-apt-repository -y ppa:ondrej/php5-5.6
apt-get update
apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt \
    php5-mysql php5-dev php5-xdebug php5-pgsql

sed -i "s/;date.timezone =/date.timezone = Europe\/Zurich/" /etc/php5/apache2/php.ini
sed -i "s/;date.timezone =/date.timezone = Europe\/Zurich/" /etc/php5/cli/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 64M/" /etc/php5/apache2/php.ini

echo "-- Configure xdebug --"
echo "
xdebug.remote_enable=1
xdebug.profiler_enable=0
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_log=/tmp/xdebug.log
xdebug.max_nesting_level=512" >> /etc/php5/apache2/conf.d/20-xdebug.ini
