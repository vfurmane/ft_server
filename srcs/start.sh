#!/bin/sh

NC="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"

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
mysql -u root -e "FLUSH PRIVILEGES;"

echo "${BLUE}Starting NGINX...${NC}"
exec "$@"
