#!/usr/bin/env bash

echo "--- Let's get to work. Installing now. ---"
locale-gen

echo "--- Updating anything list ---"
apt-get dist-upgrade -y

echo "--- Installing base packages ---"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y vim curl python-software-properties dpkg-dev wget ca-certificates \
    git-core mysql-server-5.5 python-software-properties software-properties-common htop realpath

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
# allows connections from everywhere
mysql -uroot -proot << EOF
    USE mysql;
    UPDATE user SET Host = '%' WHERE Host = '::1';
    FLUSH PRIVILEGES;
EOF

echo "--- Postgres time ---"
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
apt-get install
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update && apt-get dist-upgrade -y
apt-get -y install postgresql-9.4
sed -i 's/peer/trust/' /etc/postgresql/9.4/main/pg_hba.conf
