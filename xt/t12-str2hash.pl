#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Dumper;
use Time::HiRes qw( time );


print str_unescape( str_escape( "123\\nun" ) ) . "\n";


print '-' x 32 . "\n";

my %h = (
        "asd123" => "try\\nme",
        '999' => "qwe\n\\rty",
        );


my $h = hash2str_url( \%h );

print '-' x 32 . "\n";
print "[[$h]]\n";

my $hr = str2hash_url( $h );

print '-' x 32 . "\n";
print Dumper( $hr );

my $s = hash2str_url( $hr );

print '-' x 32 . "\n";
print "[[$s]]\n";


my $t = time();
for(1..1000000)
{
  my $h = hash2str_url( \%h );
  my $hr = str2hash_url( $h );
  my $s = hash2str_url( $hr );
}
print "time=" . ( time() - $t ) . "\n";


