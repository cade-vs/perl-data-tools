#!/usr/bin/perl
use strict;

use Time::Zone;


print tz( 'EEST' );
tz( 'EEST' ) for 1..2000000;

my $z;

print "tzo calls $z\n";

our %ZC;
sub tz
{
  my $n = shift;
  
  
  # 1st fast
  #return $ZC{ $n } || ( $ZC{ $n } = tz_offset( $n ) );
  
  # 1nd fastest!!!
  return $ZC{ $n } ||= tzo( $n );

  # way slower
  #return exists $ZC{ $n } ? $ZC{ $n } : ( $ZC{ $n } = tz_offset( $n ) );

  # near 1st fast?
  #return exists $ZC{ $n } ? $ZC{ $n } : $ZC{ $n } = tzo( $n );
}


sub tzo
{
$z++;
return tz_offset( shift )
}
