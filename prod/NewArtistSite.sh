#!/bin/bash 

if [ $# -lt 1 ]; then
	echo "Usage: $0 [options] sitename";
	exit 1
fi

SITENAME=$1

# Files
mkdir /opt/www/files/$SITENAME && chown nobody:nobody /opt/www/files/$SITENAME && chmod 705 /opt/www/files/$SITENAME

# Logs
mkdir /var/www/w3logs/$SITENAME && chown nobody:nobody /var/www/w3logs/$SITENAME && chmod 755 /var/www/w3logs/$SITENAME
mkdir /var/www/admin_logs/$SITENAME && chown nobody:nobody /var/www/admin_logs/$SITENAME && chmod 755 /var/www/admin_logs/$SITENAME