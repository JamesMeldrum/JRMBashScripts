#!/bin/bash 

if [ $# -lt 1 ]; then
	echo "Usage: $0 [options] sitename";
	exit 1
fi

SITENAME=$1

# Site root
mkdir /opt/www/$SITENAME && chown ee_dev_sync:ee_dev_sync /opt/www/$SITENAME && chmod 775 /opt/www/$SITENAME

# Files
mkdir /opt/www/files/$SITENAME && chown nobody:nobody /opt/www/files/$SITENAME && chmod 705 /opt/www/files/$SITENAME

# Logs
mkdir /var/www/w3logs/$SITENAME && chown nobody:nobody /var/www/w3logs/$SITENAME && chmod 755 /var/www/w3logs/$SITENAME
mkdir /var/www/admin_logs/$SITENAME && chown nobody:nobody /var/www/admin_logs/$SITENAME && chmod 755 /var/www/admin_logs/$SITENAME

# Assets
ln -s /opt/www/$SITENAME/site/ /opt/www/exhibit-e_libsite/site/sites/$SITENAME