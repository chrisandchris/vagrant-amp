#!/bin/bash
#
# Setup the the box. This runs as root

echo "--- Let's get to work. Installing now. ---"
locale-gen

echo "--- Updating packages list ---"
apt-get update && apt-get dist-upgrade -y

echo "--- Installing base packages ---"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y vim curl python-software-properties dpkg-dev wget ca-certificates \
    git-core mysql-server-5.5 python-software-properties software-properties-common htop

curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -
apt-get update
apt-get install --yes nodejs
sudp npm install -g gulp

echo "--- MySQL time ---"
sed -i 's/#max_connections/max_connections/' /etc/mysql/my.cnf
sed -i 's/max_connections[ ]*= 100/max_connections = 1000/' /etc/mysql/my.cnf
sed -i 's/\[mysqld\]/\[mysqld\]\nsql_mode = "NO_ENGINE_SUBSTITUTION,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ONLY_FULL_GROUP_BY"/' /etc/mysql/my.cnf
sed -i "s/bind-address.*=.*127.0.0.1/bind-address=0.0.0.0/g" /etc/mysql/my.cnf
service mysql restart
mysql -uroot -proot << EOF
    USE mysql;
    UPDATE `user` SET Host = '%' WHERE Host = '::1';
    FLUSH PRIVILEGES;
EOF

echo "--- Postgres time ---"
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
apt-get install
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update && apt-get dist-upgrade -y
apt-get -y install postgresql-9.4

echo "--- Installing PHP5.6 and Apache 2.4 ---"
add-apt-repository -y ppa:ondrej/php5-5.6
apt-get update
apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt \
    php5-mysql php5-dev php5-xdebug php5-apcu

echo "-- Configure xdebug --"
echo "xdebug.remote_enable=1
xdebug.profiler_enable=0
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_log=/tmp/php5-xdebug.log
xdebug.max_nesting_level=512
xdebug.remote_host=10.211.55.2" >> /etc/php5/apache2/conf.d/xdebug.ini

echo "--- Enabling mod-rewrite ---"
a2enmod rewrite

echo "--- Setting up web directory ---"
rm -rf /var/www/html
ln -fs /vagrant /var/www/html
mkdir -p /var/www/uploads
chmod 0777 /var/www/uploads

echo "--- Modify apache user ---"
sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=vagrant/" /etc/apache2/envvars
sed -i "s/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=vagrant/" /etc/apache2/envvars

echo "--- Turn on errors ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo "-- Modify apache configuration --"
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-enabled/000-default.conf
echo "Listen 8000" >> /etc/apache2/ports.conf
cp /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default-8000.conf
sed -i 's/<VirtualHost *:80>/<VirtualHost *:8000>/' /etc/apache2/sites-enabled/000-default-8000.conf

echo "--- Restarting Apache ---"
service apache2 restart

echo "--- Install Composer (PHP package manager) ---"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "--- Installing aliases & default config ---"
etecho "alias phpunitx=\"./vendor/phpunit/phpunit/phpunit  -dxdebug.remote_host=10.211.55.2 -dxdebug.remote_autostart=1\"" >> /home/vagrant/.bash_profile
echo "alias phpunit=\"./vendor/phpunit/phpunit/phpunit\"" >> /home/vagrant/.bash_profile
echo "alias ll=\"ls -al\"" >> /home/vagrant/.bash_profile
echo "export XDEBUG_CONFIG=\"idekey=vagrant\"" >> /home/vagrant/.bash_profile

echo "--- Updating again everything, set hostname ---"
apt-get update && apt-get dist-upgrade -y
echo "amp" >> /etc/hostname

echo "--- All done, enjoy! :) ---"
