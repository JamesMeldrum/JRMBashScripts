#! /opt/local/bin/perl -w
#
#   $Id$
# 
#   This is an example of using Panther Web Services APIs to flush
#   objects from cache. Usage of the script is as follows:
#
#   1. Rename this example file to flush.pl and enable the execute bit.
#
#   2. Execute the script:
#
# 		% ./flush.pl --user "<username>" --pass "<password>" -s <site_id> -t "(all|paths)" \
#			[--paths "<path>[\n<path>...]"] [--wildcard] [--use-ims]
#
#      This flushes two specific paths:
#
# 		% ./flush.pl --user "joe@client.com" --pass secret -s 14 -t paths \
#			--paths "/foo.jpg\n/bar.jpg" 
#
#      This flushes two wildcard paths:
#
# 		% ./flush.pl --user "joe@client.com" --pass secret -s 14 -t paths \
#			--paths "/april/*\n/may*"  --wildcard
#
#      This flushes everything from one site:
#
# 		% ./flush.pl --user "joe@client.com" --pass secret -s 14 -t all
#
#	--wildcard: forces this script to interpret the "?" and "*" characters
#	as any single character and any group of characters, respectively.
#
#	--use-ims: use If-Modified-Since when retrieving a replacement for a
#	flushed object from the origin server, and keep the old object if the
#	version on the origin server is not newer. Only valid with -t all or
#	--wildcard.
#
#   This script uses SOAP::Lite.  Please compile and install expat first from
#   expat.sf.net since it is required by XML::Parser and XML::Expat, both of
#   which SOAP::Lite uses.  To install SOAP::Lite invoke "perl MCPAN -e shell"
#   and type "install SOAP::Lite" on the CPAN prompt.
#

use SOAP::Lite;
use Getopt::Long;

sub print_usage {
	print "flush paths from a pad: $0 --user <username> --pass <password> -s <site_id> -t paths -p <newline-separated-paths> [--wildcard] [--use-ims]\n";
	print "flush all from a pad: $0 --user <username> --pass <password> -s <site_id> -t all [--use-ims]\n";
}

sub main {
	
	my $paths = '';
	my $wildcard = 0;
	my $use_ims = 0;
	
    GetOptions(
		"username=s" => \$username, 
		"password=s" => \$password,
		"site=s" => \$site,
		"type=s" => \$type,
		"paths:s" => \$paths, 
		"wildcard!" => \$wildcard,
		"use-ims!" => \$use_ims
	);
	
    if ($username && $password && $site && $type) {
    	print $username;
		print $password;
			$response = SOAP::Lite
				-> uri('urn:CacheServices')
				-> proxy('https://api.pantherexpress.net/soap/cacheflush/')
				-> flush(
					SOAP::Data->name(username => $username),
					SOAP::Data->type('string')->name(password => $password),
					SOAP::Data->name(flushtype => $type),
					SOAP::Data->name(siteId => $site),
					SOAP::Data->name(paths => $paths),
					SOAP::Data->name(wildcard => $wildcard)->type('boolean'),
					SOAP::Data->name(use_ims => $use_ims)->type('boolean')
			);
    
    	    if ($response->fault) {
    			printf "A fault (%s) occurred: %s\n", $response->faultcode, $response->faultstring; 
    	    } else {
    			print($response->result . "\n"); 
    	    }
    	
        } else {
    		print_usage();
    	}
}

main();