#!/bin/bash

echo "--- Adding repository for PHP 7 ---"
add-apt-repository -y ppa:ondrej/php-7.0
apt-get update
