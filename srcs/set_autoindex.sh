#!/bin/bash

if [ $# -ne 1 ]
then
	exit 1
fi

counter=0

for file in /etc/nginx/sites-available/*
do
	if ! grep -E "^(\s*)autoindex\s+.+;$" $file > /dev/null 2>&1
	then
		echo "The autoindex is not configured in $file"
		counter+=1
	else
		sed -Ei "s/^(\s*)autoindex\s+.+;$/\1autoindex $1;/g" $file
	fi
done

if [ $counter -gt 0 ]
then
	echo "The autoindex directive cannot be modified if it has not been configured"
fi

exec service nginx reload
