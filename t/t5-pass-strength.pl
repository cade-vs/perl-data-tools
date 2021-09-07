#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Time;

while(<>)
  {
  chomp;
  my $ps = str_password_strength( $_ );
  print "$ps\n";
  }
