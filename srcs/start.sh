#!/bin/sh

NC="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"

echo "${BLUE}Generating SSL Certificate...${NC}"
mkdir /etc/nginx/ssl
openssl req -x509 -newkey rsa:4096 -nodes -keyout /etc/nginx/ssl/localhost.key -out /etc/nginx/ssl/localhost.crt -days 365 -subj '/C=FR/ST=Paris/L=Paris/O=42Paris/CN=localhost'

echo "${BLUE}Starting PHP....${NC}"
service php7.3-fpm start

echo "${BLUE}Starting MYSQL....${NC}"
service mysql start

# Create an admin user for MySQL (cannot connect with root into PMA)

if [ -f MYSQL_PASSWORD ]
then
	export MYSQL_PASSWORD=$(cat MYSQL_PASSWORD)
else
	export MYSQL_PASSWORD="password"
fi

mysql -u root -e "CREATE USER 'vfurmane'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'vfurmane'@'localhost';"

mysql -u root -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress_password';"
mysql -u root -e "CREATE DATABASE wordpress;"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Configure phpMyAdmin

cp /usr/share/phpmyadmin/config.sample.inc.php  /usr/share/phpmyadmin/config.inc.php

if [ -f PMA_SECRET ]
then
	sed -Ei "s/\\\$cfg\['blowfish_secret'\]\s*=\s*'.*'/\$cfg['blowfish_secret'] = '$(cat PMA_SECRET)'/g" /usr/share/phpmyadmin/config.inc.php
fi

mysql -u root < /usr/share/phpmyadmin/sql/create_tables.sql

echo "${BLUE}Starting NGINX...${NC}"
echo "${GREEN}The server is running!${NC}"
exec "$@"
