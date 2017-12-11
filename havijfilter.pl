#!/usr/bin/perl
#author G66K
#Description : filter havij data email and passwd

use strict;
use warnings;
use v5.010;
use Data::Dumper;


if($#ARGV != 0 ){
	say("Usage: $0 file");
	exit;
}

chomp(my $file = $ARGV[0]);
regex(oFile($file));
sub regex{
	my @html = @_;
	my $user;
	my $passwd;
	my @info;
	foreach my $h (@html){
		if($h =~ /<td bgcolor="#FFF7F2">(.+?)<\/td>/gi){
				my $tmp = $1 if defined $1;
				if($tmp =~ /@/gi){
					$user = $tmp;
				}else{
					$passwd = $tmp;
				}
		}
		if(defined($user) && defined($passwd)){
			push(@info,"$user:$passwd");
		}
	}
	wFile(clean(@info));
}


sub clean{
	my $seen = {};
	return grep {! $seen->{$_}++ } @_;
}

sub oFile{
	my $file = shift;
	open(my $fh,'<',$file) or die $!;
	my @html = <$fh>;
	close($fh);
	return @html;
}

sub wFile{
	my @ep = @_;
	open(my $fh,'>>cleanemailandpass.txt') or die $!;
	foreach my $l (@ep){
		say $fh $l;
	}
	close($fh);
}
