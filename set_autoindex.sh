#!/bin/sh

NC="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"

# Check arguments

if ([ $# -lt 1 ] || [ $# -gt 2 ]) || !([ "$1" = "on" ] || [ "$1" = "off" ])
then
	echo "${RED}Usage: on|off [container_id]${NC}"
	exit 1;
fi

# Check if container exists

if [ $# -eq 2 ]
then
	container=$(docker ps -lq -f id=$2 -f status=running)
	err_msg="The specified container is not running or does not exist..."
else
	container=$(docker ps -lq -f status=running)
	err_msg="No ft_server container running..."
fi

if [ -z $container ]
then
	echo "${RED}$err_msg${NC}"
	exit 1;
fi

docker exec $container ./set_autoindex.sh $1
