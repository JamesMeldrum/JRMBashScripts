#!/bin/bash 

if [ $# -lt 1 ]; then
	echo "Usage: switchnetwork [home,work]";
	exit 1
fi

configfile='/Users/ryan/.ssh/config'

if [ "$1" == "work" ]; then
    cat $configfile \
    | awk '/Hostname 192.168.1.10/{gsub(/^#?/, "")}; 1' \
    | awk '/Hostname 216.156.99.166/{gsub(/^#?/, "#")}; 1' \
    | awk '/Port 9876/{gsub(/^#?/, "#")}; 1' \
    > $configfile.tmp
    
    awk '/#work/{gsub(/^#/, "")}; 1' /etc/hosts > /etc/hosts.tmp
    
elif [ "$1" == "home" ]; then
	cat $configfile \
    | awk '/Hostname 192.168.1.10/{gsub(/^#?/, "#")}; 1' \
    | awk '/Hostname 216.156.99.166/{gsub(/^#?/, "")}; 1' \
    | awk '/Port 9876/{gsub(/^#?/, "")}; 1' \
    > $configfile.tmp
    
	#awk '/#work|#home/{gsub(/^##/, "")}; 1' $configfile | awk '/#work/{gsub(/^/, "##")}; 1' > $configfile.tmp
	
	awk '/#work/{gsub(/^#?/, "#")}; 1' /etc/hosts > /etc/hosts.tmp
else
    echo "no dice"
    exit 1
fi

rm -f $configfile && mv $configfile.tmp $configfile
rm -f /etc/hosts && mv /etc/hosts.tmp /etc/hosts

dscacheutil -flushcache
