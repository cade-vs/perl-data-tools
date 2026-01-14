#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Process::Forks;
use Data::Dumper;

forks_set_max( 4 );
forks_set_start_wait_to( 3 );
forks_setup_signals();

print "parent [$$]\n";

print Data::Tools::Process::Forks::__get_max_machine_core_count();
#-----------------------------------------------------------------------------

my $c = 11;
while( $c-- )
{
  my $fr = forks_start_one();
  if( $fr eq '0E0' )
    {
    print "fork error [$!] sleeping\n";
    sleep 3;
    }
  next if $fr;  

  $SIG{ 'INT'  } = $SIG{ 'TERM' } = sub { print "+++ exit [$$]\n" };
  print "child [$$] $c started...\n";
  sleep 11 + int rand 5;
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
