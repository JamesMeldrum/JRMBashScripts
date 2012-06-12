#!/usr/bin/perl -w
use warnings;
use strict;

use File::Find;
no warnings 'File::Find';

my $dir;
my $pretend = 0;

my ($arg1, $arg2) = @ARGV;


if (!$arg1) {
	print "Usage: dbConvertSite.pl [-p] [dir]\n";
	exit;
}
if ($arg1 eq '-p') {
	if ($arg2) {
		$dir = $arg2;
		$pretend = 1;
	} else {
		print "Usage: dbConvertSite.pl [-p] [dir]\n";
		exit;
	}
} else {
	$dir = $arg1;
}


if (!-d $dir) {
	print "Not a valid directory\n";
	exit;
}

find(\&wanted, $dir);

sub wanted {
	#next if -d $_;
	return if /^\./;
	return unless /\.php$/;

	processFile($_);
}

sub processFile {
	my($file) = @_;
	my $line;
	my $found_lines = 0;

	open(INFILE, $file) || die ("Cannot open $file");
	
	undef $/;
	my $text = <INFILE>;
	close(INFILE);
	
	if ($text =~ m/mysql_[\w]+\(/) {
		if ($pretend) {
			print "Would convert: $File::Find::name\n";
			return;
		} else {
			print "Converting: $File::Find::name\n";
		}
	} else {
		return;
	}

	$text =~ s/@?mysql_query/dbQuery/g;
	$text =~ s/@?mysql_fetch_assoc/dbFetchAssoc/g;
	$text =~ s/@?mysql_fetch_row/dbFetchRow/g;
	$text =~ s/@?mysql_num_rows/dbNumRows/g;
	$text =~ s/@?mysql_insert_id/dbInsertId/g;
	$text =~ s/@?mysql_close/dbClose/g;
	$text =~ s/@?mysql_real_escape_string/dbEscape/g;
	$text =~ s/@?mysql_data_seek/dbDataSeek/g;
       
	# convert double calls down to one
	$text =~ s/dbFetchAssoc\(dbQuery\((.*)\)\);/dbFetchOne($1);/g;

	open(OUTFILE, ">$file") || die ("Cannot open $file");
	print OUTFILE $text;
	close OUTFILE;
}

#scanDirectory($dir);