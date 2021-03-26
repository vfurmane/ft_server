#!/bin/sh

NC="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"

# Line from the the official NGINX image. For Docker containers, the 'daemon off;' directive tells NGINX to stay in the foreground.
nginx -g "daemon off;"

if service nginx start
then
	echo "${GREEN}NGINX started!${NC}"
else
	echo "${RED}NGINX failed to start...${NC}"
fi
