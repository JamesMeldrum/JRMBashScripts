#!/bin/bash

/bin/echo -n "Are you sure you want to remove all traces of exhibit-E [N]? "
read continue

if [[ "$continue" != "Y" && "$continue" != "y" ]]; then
	exit;
fi

#aliases
sudo rm -rf /var/www

# libs
sudo rm -rf /usr/local/exhibit-e.com /usr/local/as_libs

# misc files
sudo rm -rf ~/website_tmp ~/website_files ~/ee_websites /var/ee_site_files

echo ""
echo "all traces removed"
echo ""