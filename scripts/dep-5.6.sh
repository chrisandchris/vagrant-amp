#!/usr/bin/env bash


echo "--- Installing PHP5.6 and Apache 2.4 ---"
add-apt-repository -y ppa:ondrej/php5-5.6
apt-get update
apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt \
    php5-mysql php5-dev php5-xdebug
