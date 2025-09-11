#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Dumper;
use Time::HiRes qw( time );


print str_unescape( "123\\\nqwe" ) . "\n";


print '-' x 32 . "\n";

my %h = (
        "asd123" => "try\\nme",
        '999' => "qwe\n\\rty",
        );


my $h = hash2str( \%h );

print '-' x 32 . "\n";
print "[[$h]]\n";

my $hr = str2hash( $h );

print '-' x 32 . "\n";
print Dumper( $hr );

my $s = hash2str( $hr );

print '-' x 32 . "\n";
print "[[$s]]\n";


my $t = time();
for(1..1000000)
{
  my $h = hash2str( \%h );
  my $hr = str2hash( $h );
  my $s = hash2str( $hr );
}
print "time=" . ( time() - $t ) . "\n";


