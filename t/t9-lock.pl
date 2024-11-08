#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Process;
use Data::Dumper;

print "running pid $$\n";

my $res = pidfile_create( 't9.pid', STALE_CHECK => 1 );
die "cannot create pidfile or process is already running with pid [$res]" if $res;

#my $res = file_lock_ex( 't7.pl' );
#my $ss  = $res ? 'YES' : 'no';
my $ss = file_lock( 't77.pl' );
print "locked: $ss\n";

sleep 5;

my $pidfh = pidfile_create( 't9.pid', LOCK => 1 );

print "pidfile locked: $pidfh\n";

sleep 10;

pidfile_remove( 't9.pid' );
