#!/usr/bin/perl
# CODED BY AntiGov @ ma
# IDEA BY STRYNGS

use strict;
use warnings;
use WWW::UserAgent::Random;
use Term::ANSIColor qw(:constants);
use LWP;
use 5.010;
if ( $#ARGV != 1 ) {
    say("Usage: ./$0 InFile OutFile");
    exit(0);
}

my $infile  = $ARGV[0];
my $outfile = $ARGV[1];
open( FN, '<', $infile ) or die $!;
my @ips = <FN>;

my $user_agent = rand_ua("browsers");
my $req        = new LWP::UserAgent;
$req->agent($user_agent);
$req->proxy( [ 'https', 'http' ], 'http://127.0.0.1:8118/' );

foreach my $ip (@ips) {
    chomp($ip);

    say( BOLD YELLOW, "[+]Status: Searching: " . BOLD WHITE, "$ip" );

    my $url  = 'https://www.robtex.com/q/x1?q=' . $ip . '&l=go';
    my $resp = $req->get($url);
    my $body = $resp->content;
    my @x    = ( $body =~ />host\sname\s<b>(.+)<\/b>/g );
    foreach (@x) {
        my $url = $_;
        say( BOLD WHITE, "[+]Found: " . BOLD GREEN, "$url" );
        open( FN, '>>', $outfile ) or die $!;
        print FN "$url\n";

    }
}
