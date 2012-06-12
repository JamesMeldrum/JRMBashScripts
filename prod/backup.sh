#!/bin/bash

rsync -a -z --delete --progress --stats -e '/usr/bin/ssh -i /root/.ssh/backup -p 63295' /opt/www/ root@10.10.129.70:/opt/www/
rsync -a -z --delete --progress --stats -e '/usr/bin/ssh -i /root/.ssh/backup -p 63295' /usr/local/exhibit-e.com/ root@10.10.129.70:/usr/local/exhibit-e.com/
rsync -a -z --delete --progress --stats -e '/usr/bin/ssh -i /root/.ssh/backup -p 63295' /etc/httpd/ee_conf.d/ root@10.10.129.70:/etc/httpd/ee_conf.d/
rsync -a -z --delete --progress --stats -e '/usr/bin/ssh -i /root/.ssh/backup -p 63295' /var/www/admin_logs/ root@10.10.129.70:/var/www/admin_logs/
rsync -a -z --delete --progress --stats -e '/usr/bin/ssh -i /root/.ssh/backup -p 63295' /var/www/w3logs/ root@10.10.129.70:/var/www/w3logs/
rsync -a -z --delete --progress --stats -e '/usr/bin/ssh -i /root/.ssh/backup -p 63295' /var/lib/awstats root@10.10.129.70:/var/lib/awstats