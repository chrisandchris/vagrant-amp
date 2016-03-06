#!/usr/bin/env bash

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
echo "alias phpunitx=\"./vendor/phpunit/phpunit/phpunit  -dxdebug.remote_host=10.211.55.2 -dxdebug.remote_autostart=1\"" >> /home/vagrant/.bash_profile
echo "alias phpunit=\"./vendor/phpunit/phpunit/phpunit\"" >> /home/vagrant/.bash_profile
echo "alias ll=\"ls -al\"" >> /home/vagrant/.bash_profile
echo "export XDEBUG_CONFIG=\"idekey=vagrant\"" >> /home/vagrant/.bash_profile
echo "EOF
    mkdir -p /vagrant/.sql_dumps
    mysql -uroot -proot -N -e 'show databases;' | while read dbname; do mysqldump -uroot -proot --complete-insert "$dbname" > "/vagrant/.sql_dumps/$dbname".sql; done" >> /home/vagrant/backup_databases.sh
ln -s /home/vagrant/backup_databases.sh /etc/rc0.d/backup_databases.sh
ln -s /home/vagrant/backup_databases.sh /etc/rc6.d/backup_databases.sh

echo "--- Updating again everything, set hostname ---"
apt-get update && apt-get dist-upgrade -y
echo "amp" >> /etc/hostname

echo "--- All done, enjoy! :) ---"
