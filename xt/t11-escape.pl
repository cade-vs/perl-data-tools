#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Dumper;


my $z = { "printme" => "multi\nrow" };

print Dumper( $z );

my $s = hash2str( $z );

print Dumper( $s );

my $x = str2hash( $s );

print Dumper( $x );

print Dumper str2hash( 'a=1\\n2' );

print ( 'a=1\\n2' );

print "==============================\n";

print Dumper( str2hash( hash2str( { a => '1\\n2' } ) ) );



print Dumper( str_html_escape( "те & това <е>" ) );
print Dumper( str_html_unescape( str_html_escape( "те & това <е> &amp; that &laquo;" ) ) );
