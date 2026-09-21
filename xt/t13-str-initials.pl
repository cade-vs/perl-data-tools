#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Dumper;
use Time::HiRes qw( time );


my $inits = str_initials( "James Webb Telescope" );

print "$inits\n";
