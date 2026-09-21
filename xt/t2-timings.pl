#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Time;
use Time::HiRes qw( time );

my $res = str_pad( "This is", 32, '*' );
print $res . "\n";
print '*' x 32 . "\n";

my $cnt = 2000_000;
my $s = time;
$res = str_pad_center( "This is", 32, '*' ) for 1..$cnt;
my $e = time() - $s;

print ( str_num_comma( $cnt / $e ) . " cps\n" );
