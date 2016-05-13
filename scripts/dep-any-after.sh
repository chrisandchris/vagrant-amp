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

echo "--- Generating and installing ssl certificate cron script ---"
(crontab -l 2>/dev/null; echo "@reboot /home/vagrant/install_cert.sh ") | crontab -
cat <<EOF >> /home/vagrant/install_cert.sh
if [ -f /etc/ssl/vagrant/vagrant.key ]; then
    exit
fi
sudo mkdir -p /etc/ssl/vagrant/
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/vagrant/vagrant.key \
    -out /etc/ssl/vagrant/vagrant.crt \
    -subj "/C=CH/ST=Zurich/L=Zurich/O=Your Dev-Env/OU=A vagrant box/CN=172.28.128.3"
sudo a2enmod ssl
cat <<-EOG  > /etc/apache2/sites-enabled/000-default-443.conf
<VirtualHost *:443>
    DocumentRoot /var/www/html
    SSLEngine on
    SSLCertificateFile /etc/ssl/vagrant/vagrant.crt
    SSLCertificateKeyFile /etc/ssl/vagrant/vagrant.key
</VirtualHost>
EOG
sudo service apache2 restart
EOF
chmod +x /home/vagrant/install_cert.sh

echo "--- Restarting Apache ---"
service apache2 restart

echo "--- Install Composer (PHP package manager) ---"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "--- Installing aliases, default config, and some tools ---"
# aliases
cat << EOF >> /home/vagrant/.bash_profile
export HOST=$(echo `ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'` | sed "s/\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)/\1\.\2\.\3\.2/")
alias phpx="php -dxdebug.remote_host=$HOST -dxdebug.remote_autostart=1"
alias phpunitx="./vendor/phpunit/phpunit/phpunit  -dxdebug.remote_host=$HOST -dxdebug.remote_autostart=1"
alias phpunit="./vendor/phpunit/phpunit/phpunit"
alias ll="ls -al"
export XDEBUG_CONFIG="idekey=vagrant"

EOF
# mysql backup script
cat << EOF > /home/vagrant/backup_mysql.sh
#!/usr/bin/env bash

mkdir -p /vagrant/.sql_dumps
mysql -uroot -proot -N -e 'show databases;' | while read dbname; do mysqldump -uroot -proot --databases \$dbname --complete-insert  > /vagrant/.sql_dumps/\${dbname}.sql; done
EOF
chmod +x /home/vagrant/backup_mysql.sh
cat << EOF >> /etc/init/mysql.conf

pre-stop script
    /home/vagrant/backup_mysql.sh
end script

EOF

echo "--- Updating again everything, set hostname ---"
apt-get update && apt-get dist-upgrade -y
echo "amp" > /etc/hostname
sed -i.old '/^.*packer.*$/d' /etc/hosts
cat << EOF >> /etc/hosts
127.0.0.1   amp
EOF

echo "--- All done, enjoy! :) ---"
