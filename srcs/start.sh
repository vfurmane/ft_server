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

echo "${BLUE}Starting NGINX...${NC}"
exec "$@"
