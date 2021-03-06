#!/usr/bin/perl
#ProxyGraper Coded By AntiGov

#Requires Modules
use strict;
use warnings;
use WWW::Mechanize;
use WWW::UserAgent::Random;
use Term::ANSIColor qw(:constants);
use Geo::IP;
use threads;
use Thread::Queue;
use MIME::Base64;
use v5.10;

sub info {

    #Display Banner
    my $banner = <<EOF;
______                    _____                           
| ___ \                  |  __ \                          
| |_/ / __ _____  ___   _| |  \/_ __ __ _ _ __   ___ _ __ 
|  __/ '__/ _ \ \/ / | | | | __| '__/ _` | '_ \ / _ \ '__|
| |  | | | (_) >  <| |_| | |_\ \ | | (_| | |_) |  __/ |   
\_|  |_|  \___/_/\_\\__, |\____/_|  \__,_| .__/ \___|_|   
__/ |               | |              
|___/ Coded By G66k |_|              
EOF
    say( BOLD, GREEN, $banner );
}
info();

# Some Variables
my ( $ip, $port, @proxy, @result );
my $page = 1;
say( BOLD RED, "# Please Wait Graping Proxy.." );
SecSite();
while ( $page <= 10 ) {    #greping 10 Pages max 67
    my $user_agent = rand_ua("browsers");     #random UserAgent;
    my $mech       = WWW::Mechanize->new();
    $mech->agent($user_agent);
    $mech->ssl_opts( verify_hostname => 0 );
    $mech->timeout(15);
    my $url = "http://www.proxylisty.com/ip-proxylist-$page";
    $mech->get($url);
    
    my $res = $mech->content;
    my @b   = parse($res);
    push( @result, @b );

    if ( $page == 10 ) {                      #check if we reach 10 Pages
        say( BOLD WHITE, "# Proxy Found: " . "[" . scalar(@result) . "]" );
        say( BOLD BLUE,  "# Checking Working Proxy.." );
        my $q = Thread::Queue->new();         #MultiTreads Start Here
        $q->enqueue($_) for @result;
        my $thread_limit
            = 10;    #Defauls Treads 10 Increase it if you have Good Machine
        my @thr = map {
            threads->create(
                sub {
                    while ( defined( my $ip = $q->dequeue_nb() ) ) {
                        check($ip);
                    }
                }
            );
        } 1 .. $thread_limit;
        $_->join() for @thr;
    }
    $page++;
}

sub SecSite {

    my @result;
    my $page = 0;
    while ( $page <= 10 ) {
        my $user_agent = rand_ua("browsers");
        my $mech = WWW::Mechanize->new( autocheck => 1 );
        $mech->agent($user_agent);
        $mech->ssl_opts( verify_hostname => 0 );
        $mech->timeout(15);
        my $url = "https://proxy-list.org/english/index.php?p=$page";
        $mech->get($url);
      sleep(2);

        my $res = $mech->content;


        my @b = parse2($res);
        push( @result, @b );
        if ( $page == 10 ) {    #check if we reach 10 Pages
            say( BOLD WHITE,
                "# Proxy Found: " . "[" . scalar(@result) . "]" );
            say( BOLD BLUE, "# Checking Working Proxy.." );
            my $q = Thread::Queue->new();    #MultiTreads Start Here
            $q->enqueue($_) for @result;
            my $thread_limit
                = 10;  #Defauls Treads 10 Increase it if you have Good Machine
            my @thr = map {
                threads->create(
                    sub {
                        while ( defined( my $ip = $q->dequeue_nb() ) ) {
                            if ( $ip eq '' ) { next; }
                            check($ip);
                        }
                    }
                );
            } 1 .. $thread_limit;
            $_->join() for @thr;
        }

        $page++;
    }

}

#Parsing Html content from proxy:port
sub parse {
    my $a = $_[0];
    my @proxy;
     my %x = ( $a =~ /<td>(\d+\.\d+\.\d+\.\d+)<\/td>\s+<td><a\shref='\S+'\stitle='\S+\s\S+\s\S+\s\S+'>(\d+)<\/a><\/td>/g );

        while(my ($k,$v) = each %x ){
            my $url = ($k.":".$v);
            push(@proxy,$url);

        }
      
    return @proxy;
}

sub parse2 {

    my $a = $_[0];
    my @proxy;
     my @x = ( $a =~ /class="proxy"><script\stype="text\/javascript">Proxy\('(.+)'\)<\/script>/g );
       
        foreach (@x) {
            my $url = decode_base64($_);
            
        push( @proxy, $url );

    }
    return @proxy;
}

#Checking Working Proxy
sub check {
    my @ips = @_;
    my $url = 'http://icanhazip.com';
    for ( my $i = 0; $i <= $#ips; $i++ ) {
        chomp( $ips[$i] );
        my $ua = LWP::UserAgent->new;
        $ua->proxy( 'http', "http://" . $ips[$i] );
        $ua->default_header( "Host" => "icanhazip.com" );
        $ua->agent(
            "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6"
        );
        $ua->default_header( "Accept" =>
                "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
        );
        $ua->default_header( "Accept-Language" => "en-US,en;q=0.5" );
        $ua->default_header( "Accept-Encoding" => "gzip, deflate" );
        $ua->default_header( "Connection"      => "keep-alive" );
        $ua->default_header( "Cache-Control"   => "max-age=0" );
        $ua->timeout(30);
        my $response = $ua->get($url);

        if ( $response->is_success ) {
            ipInfo( $ips[$i] );
        }
    }
}

#Lookup Proxy
sub ipInfo {
    no warnings "uninitialized";    #Disable some anonying errors
    my $ip     = $_[0];
    my @r      = split( ":", $ip );
    my $gi     = Geo::IP->open( "GeoIP/GeoLiteCity.dat", GEOIP_STANDARD );
    my $record = $gi->record_by_addr( $r[0] );
    my $ok     = (
        BOLD YELLOW,
        $ip . " : " . BOLD WHITE,
        $record->country_code3 . " : "
            . $record->country_name . " : "
            . $record->region_name
            . BOLD GREEN,
        " [Ok]"
    );
    say($ok);
    open( SUCCESSFILE, '>>success.txt' );
    print SUCCESSFILE $ok . "\n";
    close(SUCCESSFILE);
}
