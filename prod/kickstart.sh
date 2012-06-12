#!/bin/bash


# 1. Either:
#     - request new machine and add hostname to puppet config or
#     - OS reload at https://manage.softlayer.com/Hardware/osReloadHardware
# 
# 2. run svn+ssh://dev.exhibit-e.com/var/svn/libs/bash/trunk/prod/kickstart.sh
#

chkconfig gpm off && service gpm stop
chkconfig netfs off  && service netfs stop
chkconfig sendmail off  && service sendmail stop
chkconfig nfslock off  && service nfslock stop
chkconfig portmap off  && service portmap stop

# Get rid of some default
yum erase -y cups cups-libs wpa_supplicant avahi
yum groupremove -y "X Window System"
yum erase -y samba vsftpd
yum erase -y samba-client samba-common
yum erase -y mysql
yum erase -y php php-devel php-imap php-cli php-common php-ldap

{
    echo "[epel]"
    echo "name=Epel from fedora"
    echo "baseurl=http://download.fedora.redhat.com/pub/epel/5/x86_64/"
    echo "gpgcheck=0"
} > /etc/yum.repos.d/EPEL.repo

echo "10.8.1.227      puppet" >> /etc/hosts

yum install puppet
chkconfig --add puppet
chkconfig --level 345 puppet on

echo "Run the following on puppetmaster:"
echo ""
echo "puppetca -r `hostname`"
echo "puppetca --clean `hostname`"
echo "service puppetmaster restart"
echo ""
read -p "Then hit [Enter] to continue. "

/etc/init.d/puppet once -v

echo "Now run the following on puppetmaster:"
echo ""
echo "puppetca --sign --all"
echo ""
read -p "Then hit [Enter] to continue. "

puppetd --waitforcert 60 --test
