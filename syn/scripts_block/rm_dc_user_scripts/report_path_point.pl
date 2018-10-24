#!/bin/perl
use Getopt::Long;


GetOptions(
	'type=s' => \$type,
);

while (<>) {
	chomp($line = $_);
	if ($type eq "both") {
		if ($line =~ /Startpoint/ or $line =~ /Endpoint/) {
			print "$line\n";
		}
	} elsif ($type eq "start") {
		if ($line =~ /Startpoint/) {
			print "$line\n";
		}
	} else {
		if ($line =~ /Endpoint/) {
			print "$line\n";
		}
	}
}

