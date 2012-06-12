#!/usr/bin/perl
#
# Program: deployallsites.pl
#
# Author: Ryan Quigley <ryan@exhibit-e.com>
#
# Current Version: 1.0.1
#
# Revision History:
# 03.30.09 (1.0.0) - Initial Release
#
# Purpose:
#  siteupdates all the sites
#
# Requirements:
#   siteupdarte
#
# Installation:
#
# Usage:
#
# Example:
#
#  $ deployallsites.pl SITENAME
#

use warnings;
#use strict; # TODO, off because of yaml traversal

use DBI;

use File::Find;
use File::Slurp;

no warnings 'File::Find';

use Term::ReadKey;


my $SVN_SERVER_ROOT		= "file:///var/svn/sites";
my $SVN_BIN				= "/usr/bin/svn";

#my $PROD_IP				= '174.37.33.190';
#my $PROD_PORT			= '';
#my $PROD_USER			= 'ee_dev_sync';
#my $PROD_SITE_ROOT		= "/opt/www";
#my $PROD_HTTP_CONF_ROOT	= "/etc/httpd/ee_conf.d";

my $MYSQL_BIN			= "/usr/bin/mysql";
my $MYSQL_DB			= "sitemanager";
my $MYSQL_USER			= "sitemanager";
my $MYSQL_PASS			= "Uo9iifoh";

#my $SITEMANAGER_DIR		= "/var/siteupdate";
#my $SITE_SVN_DIR		= "$SITEMANAGER_DIR/svn";
#my $SITE_PRODUCTION_DIR	= "$SITEMANAGER_DIR/on_production";
#my $HTTP_CONFIG_DIR		= "$SITEMANAGER_DIR/http_configs";

#my $HTPASSWD_BIN		= "/usr/local/apache2/bin/htpasswd";


print "Are you sure you want to sync everything? [y]: ";
$|++;
ReadMode 'cbreak';
my $key = ReadKey[0];
ReadMode 'normal';

if ($key eq 'n' || $key eq 'N') {
	print "\n";
	exit 0;
}


my $dbh = DBI->connect("DBI:mysql:$MYSQL_DB:localhost:3306", $MYSQL_USER, $MYSQL_PASS, { RaiseError => 1}) || die "Can't connect to DB: $DBI::errstr";

my $sth = $dbh->prepare("SELECT identifier FROM sites WHERE identifier != '' and live = 1;");
$sth->execute;

while ($row_ref = $sth->fetchrow_hashref())
{
	print "Syncing: $row_ref->{identifier}\n";
	system("siteupdate -f $row_ref->{identifier}");
}
