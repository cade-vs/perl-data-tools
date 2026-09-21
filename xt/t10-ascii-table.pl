#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Dumper;


my $t = [
        [ qw( test this awesome ascii table ) ],
        [ qw( 7475 56574 hhf 8f8f fff ) ],
        [ qw( 5 6 43 8 99999999999999999 ) ],
        [ qw( fgh fgh tyj dsfg kio ) ],
        ];

my $h = [
             {
             E => 'RE:\d+[a-f]*',  # regexp match
             F => 'REI:\d+[a-f]*', # case insensitive regexp match
             },
             {
             E => '123abc',
             G => '456FFF',
             },
        ];

print format_ascii_table( $t );
print format_ascii_table( $h );
