#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
use SQL qw(SQL CLEAN);
use BING qw(SEARCH);
use URI::Escape;
use Term::ANSIColor qw(:constants);
use threads;
use Thread::Queue;


if($#ARGV != 0){
 say("Usage: $0 Dork");
 exit(0);
}
my @words =('Nokia','samsung','milk', 'food', 'playstation', 'place order', 'contact us', 'shopping','Buy Now','View Cart','Add to Cart',
             'boutique','store','toys','DVD','iphones','shop','sell','billing','purchase now','protein','Games','paypal','shoes',
             'sport','chairs','order','electronic','clothes','online shopping','we accept','sell','drinks'
 );

my $file = $ARGV[0];
open(my $fh,'<',$file) or die $!;
my  @dorks = <$fh>;
close($fh);
foreach my $dork(@dorks){
    	    my $q = Thread::Queue->new(); 
	       $q->enqueue($_) for @words;
	    my $thread_limit = 10;  
	    my @thr = map {
	    threads->create(sub {
        while (defined (my $word = $q->dequeue_nb())) {   
	chomp($dork);
	my @links = SEARCH($dork." ".$word);
	sleep(5);
	my @res = CLEAN(@links);
	sleep(5);
	my $c = scalar @res;
	say(BOLD YELLOW,"CLEAN UP: " .$c);	
	SQL(@res);
	sleep(30);
	}});} 1..$thread_limit; $_->join() for @thr;
}


