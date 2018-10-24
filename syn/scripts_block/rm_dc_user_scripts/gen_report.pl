#!/bin/perl
use Getopt::Long;

#Timing Path Group 'CEVA_EPP_WDOG_CLK'
#Critical Path Slack:          -0.03
#Total Negative Slack:         -0.21
#No. of Violating Paths:       18.00

GetOptions(
	'type=s' => \$type,
);

my %qor;

while (<>) {
	chomp($line = $_);
	if ($line =~ /Timing Path Group.*'(.*)'/) {
		$group_name = $1;
	}
	if ($line =~ /Critical Path Slack.* (-?\d+\.\d+)/) {
		$qor{$group_name}{WORST_SLACK} = $1;
	} 
	if ($line =~ /Total Negative Slack.* (-?\d+\.\d+)/) {
		$qor{$group_name}{TOTAL_SLACK} = $1;
	} 
	if ($line =~ /No\. of Violating Paths.* (\d+\.\d+)/) {
		$qor{$group_name}{SLACK_NUMBER} = $1;
	} 
}

if ($type eq "tns") {
	@keys = sort {$qor{$a}{TOTAL_SLACK} <=> $qor{$b}{TOTAL_SLACK}} keys %qor;
} elsif ($type eq "num") {
	@keys = sort {$qor{$b}{SLACK_NUMBER} <=> $qor{$a}{SLACK_NUMBER}} keys %qor;
} else {
        @keys = sort {$qor{$a}{WORST_SLACK} <=> $qor{$b}{WORST_SLACK}} keys %qor;
}

print "Path Group\t\tWNS(ns)\t\tTNS(ns)\t\tNumber of Violations\n";

foreach $key (@keys) {
	if (length($key) > 15){
		print "$key\t";
	} elsif (length($key) > 7){
		print "$key\t\t";
	} else {
		print "$key\t\t\t";
	}
	print "$qor{$key}{WORST_SLACK}\t\t";
	if (length($qor{$key}{TOTAL_SLACK}) > 7){
		print "$qor{$key}{TOTAL_SLACK}\t";
	} else {
		print "$qor{$key}{TOTAL_SLACK}\t\t";
	}
	print "$qor{$key}{SLACK_NUMBER}\n";
}




#my %hash;
#$hash{a}{WORST_SLACK} = 3.3;
#$hash{b}{WORST_SLACK} = -5.9;
#$hash{c}{WORST_SLACK} = 1.4;
#
#my @keys = sort {$hash{$b}{WORST_SLACK} <=> $hash{$a}{WORST_SLACK}} keys %hash;
#
#foreach $key (@keys)
#{
#	print "$key $hash{$key}{WORST_SLACK}\n";
#}
