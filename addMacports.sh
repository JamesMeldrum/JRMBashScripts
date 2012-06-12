#!/bin/bash

#if [ -f $HOME/.ssh/config ]; then
	{
		echo "host devsvn"
		echo "	ForwardAgent no"
		echo "	ForwardX11 no"
		echo "  User $USER"
	} >> $HOME/.ssh/config
#fi

sudo port selfupdate

# Subversion
sudo port install subversion +bash_completion +no_bdb +tools
echo 'add the following to ~/.bash_profile'
echo "if [ -f /opt/local/etc/bash_completion ]; then"
echo "	. /opt/local/etc/bash_completion"
echo "fi\n"
echo ""

# Apache
sudo port install apache2 +preforkmpm
echo 'place the contents of http://dev.exhibit-e.com/wiki/images/8/83/Httpd.conf in there and change any references of "USER" to your OS X short account name and/or email address'
sudo port load apache2
echo ""

# MySQL
sudo port install mysql5-server mysql5
sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist
sudo -u mysql mysql_install_db5
/opt/local/lib/mysql5/bin/mysql_secure_installation

sudo port install curl +ssl

# PHP
sudo port install php5 +suhosin +pear
sudo port install php5-mcrypt php5-mysql php5-mbstring php5-apc php5-soap php5-iconv php5-curl php5-openssl
cd /opt/local/apache2/modules
sudo /opt/local/apache2/bin/apxs -a -e -n "php5" libphp5.so
echo 'place the contents of http://dev.exhibit-e.com/wiki/images/e/e0/Php.ini in there'
echo ""

# GraphicsMagick
sudo port install GraphicsMagick 

# dnsmasq
sudo port install dnsmasq
echo 'mate /opt/local/etc/dnsmasq.conf (or use this: http://dev.exhibit-e.com/wiki/images/c/c0/Dnsmasq.conf)'


# Paths
sudo mkdir /var/www
sudo ln -s /Users/$USER/ee_websites /var/www/ee_websites

sudo mkdir /usr/local
sudo ln -s /Users/$USER/ee_websites/exhibit-e.com /usr/local/exhibit-e.com

#sudo mkdir /var/www/logs
sudo ln -s /opt/local/apache2/logs /var/www/logs with 
sudo chown $USER on /opt/local/apache2/logs

sudo mkdir -p ~/website_tmp/{smarty/{templates_c,cache},twig,files}

{
    echo '<?xml version="1.0"?>'
    echo '<cross-domain-policy>'
	echo '    <site-control permitted-cross-domain-policies="master-only" />'
	echo '    <allow-access-from domain="*.dev" />'
    echo '</cross-domain-policy>'
} > ~/website_tmp/crossdomain.xml;

svn co svn+ssh://devsvn/var/svn/libs/exhibit-e.com/trunk ~/ee_websites/exhibit-e.com
svn co svn+ssh://devsvn/var/svn/libs/actionscript/trunk ~/ee_websites/as_libs

mkdir ~/ee_websites/admin_assets && cd ~/ee_websites/admin_assets && ln -s ~/ee_websites/exhibit-e.com/eeSiteAdmin/img && ln -s ~/ee_websites/exhibit-e.com/eeSiteAdmin/js_admin && ln -s ~/ee_websites/exhibit-e.com/eeSiteAdmin/style.css

#ennouncements
ln -s ~/ee_websites/exhibit-e.com/ennouncements_admin/ /Users/$USER/Sites/ennouncements_admin

#make sure pear config is ok

####################################################
# go to system prefs->network change dns servers to:
# 127.0.0.1,192.168.1.254
sudo ln -s /etc/resolv.conf /opt/local/etc/resolv.conf
#sudo launchctl load -w /Library/LaunchDaemons/org.macports.dnsmasq.plist
# use this for second step: http://blog.steamshift.com/geek/leopard-lookupd-and-local-web-development-sites

#if you're on airport, you might have to manually set the dns servers:
#(with opendns):
#sudo networksetup -setdnsservers Airport 127.0.0.1 208.67.222.222 208.67.220.220



mkdir -p ~/bin
cd ~/bin
svn export svn+ssh://devsvn/var/svn/libs/bash/trunk/siteupdate && chmod +x siteupdate
svn export svn+ssh://devsvn/var/svn/libs/bash/trunk/setupSite && chmod +x setupSite
