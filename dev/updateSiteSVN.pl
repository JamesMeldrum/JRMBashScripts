#!/usr/bin/perl
#
# Program: updateSiteSVN.pl
#
# Author: Ryan Quigley <ryan@exhibit-e.com>
#
# Current Version: 1.0.1
#
# Revision History:
# 08.10.10 (1.0.0) - Initial Release
#
# Purpose:
#  keep current sites available for sitefind
#
# Requirements:
#
# Installation:
#
# Usage:
#
# Example:
#
#  $ updateSiteSVN.pl
#

use warnings;
#use strict; # TODO, off because of yaml traversal

use DBI;

my $SVN_SERVER_ROOT		= "file:///var/svn/sites";
my $SVN_BIN				= "/usr/bin/svn";

my $DEV_GROUP			= 'dev_syncable';

my $MYSQL_BIN			= "/usr/bin/mysql";
my $MYSQL_DB			= "sitemanager";
my $MYSQL_USER			= "sitemanager";
my $MYSQL_PASS			= "Uo9iifoh";

my $SITEMANAGER_DIR		= "/var/siteupdate";
my $SITE_SVN_DIR		= "$SITEMANAGER_DIR/svn";
my $SITE_PRODUCTION_DIR	= "$SITEMANAGER_DIR/on_production";
my $HTTP_CONFIG_DIR		= "$SITEMANAGER_DIR/http_configs";

# Remove all old sites
system("rm -rf $SVN_SERVER_ROOT/*");


my $dbh = DBI->connect("DBI:mysql:$MYSQL_DB:localhost:3306", $MYSQL_USER, $MYSQL_PASS, { RaiseError => 1}) || die "Can't connect to DB: $DBI::errstr";

my $sth = $dbh->prepare("SELECT identifier FROM sites WHERE identifier != '' AND live = 1 ORDER BY identifier;");
$sth->execute;

umask 0002;

while ($row_ref = $sth->fetchrow_hashref())
{
	my $sitename = $row_ref->{identifier};

	print "Adding $sitename\n";
	system("$SVN_BIN --quiet co $SVN_SERVER_ROOT/$sitename/trunk $SITE_SVN_DIR/$sitename");
}

system("chgrp -R $DEV_GROUP $SITE_SVN_DIR/*");
