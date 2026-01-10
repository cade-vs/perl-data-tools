#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Process::Forks;
use Data::Dumper;

forks_set_max( 6 );

print "parent [$$]\n";

#-----------------------------------------------------------------------------

my $c = 11;
while( $c-- )
{
  forks_start_one() and next;

  print "child [$$] $c started...\n";
  sleep 15 + int rand 5;
  exit;
}  

sleep 2;
printf "waiting all... 1\n";
forks_wait_all();
printf "done 1\n";

#-----------------------------------------------------------------------------

my $c = 11;
forks_start_one( undef, \&ccc ) while( $c-- );

sleep 2;
printf "waiting all... 2\n";
forks_wait_all();
printf "done 2\n";

#-----------------------------------------------------------------------------

sub ccc
{
  print "ccc child [$$] $c started...\n";
  sleep 15 + int rand 5;
  return 0;
}
