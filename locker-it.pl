#!/usr/bin/perl
#Author: G66K
# http://locker-it.com Bot to check new Post And Messages

use  strict;
use warnings;
use v5.010;
use Data::Dumper;
use WWW::Mechanize;
use HTTP::Cookies;
use utf8;
use open ':std', ':encoding(UTF-8)';

my $username = 'G66K'; #Your UserName
my $password = 'P4$$WORD'; #Your PassWord

my $url = 'http://locker-it.com/vb/index.html';


my $mech = WWW::Mechanize->new();
$mech->cookie_jar(HTTP::Cookies->new());
$mech->get($url);
$mech->submit_form(
        form_number => 2,
        fields      => {
            vb_login_username    => $username,
            vb_login_password    => $password,
        }
    );
$mech->submit();

$mech->get('http://locker-it.com/vb/search-do_getnew.html');
my $content = $mech->content();

if($content =~ /<a\s+href=member-u_5853\.html>$username<\/a>/g){

if($content =~ /<div\s[^>]+>\s+<[a-z]+>(.+?)\s+,/){
	my $user = $1 if defined $1;
	say $user." : ".$username;
}
if($content =~ /<div><a href=private\.html>(.+)<\/div>/){
	my $message = $1 if defined $1;
	$message =~ s/<[^>]+>//g;
	say $message;
}
say("############################ المشاركات الجديدة ##############################");
my @newPost = ($content =~ /style=\"font-weight:bold\">(.+)<\/a>/g);
   if(@newPost){
	foreach my $post (@newPost){
		say $post if defined $post;
say("############################ المشاركات الجديدة ##############################");
   }
	}else{say("عذراً, ليست هناك مواضيع أو مشاركات جديدة للمشاهدة.");}
	
}
