#!/usr/bin/perl
#Author: G66K @ MA
#Description: LooKup single ip or file mass looKup

use strict;
use warnings;
use v5.010;
use WWW::Mechanize;

if($#ARGV != 0){
	say("Usage: $0 IP-ADDRESS|FILE-OF-IP-ADDRESS");
	exit;
}
chomp(my $ip = $ARGV[0]);

if( -e $ip){
	foreach my $i (oFile($ip)){
		lookup($i);
	}
}else{
	lookup($ip);
}

sub lookup{
	my $ip = shift;
	my $mech = WWW::Mechanize->new(autocheck => 0);
	$mech->get('http://ip-api.com/json/'.$ip);
	my $content = $mech->content;
	my %info = ($content =~ /"(.+?)":"(.+?)"/gi);
	say("-----------------------Start-------------------------");
	while(my ($key,$value) = each %info){
		say $key . " => " . $value;
	}
	say("-----------------------End---------------------------");
}
sub oFile{
	my $file = shift;
	open(my $fh,'<',$file) or die $!;
	my @ips = <$fh>;
	chomp(@ips);
	close($fh);
	return @ips;
}
