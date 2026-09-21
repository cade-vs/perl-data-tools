#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Time;
use Date::Format;
use Time::JulianDay;


my $jd = local_julian_day( time() );

print julian_date_format( $jd ) . "\n";

$jd = julian_date_add_ymd( $jd, -1, 1, 2 );

print julian_date_format( $jd ) . "\n";

my ( $y, $m, $d ) = julian_date_to_ymd( $jd );

print "( $y, $m, $d )\n";

$jd = julian_date_from_ymd( $y, $m, $d );

print julian_date_format( $jd ) . "\n";

$jd = julian_date_goto_first_dom( $jd );

print julian_date_format( $jd ) . "\n";

$jd = julian_date_goto_last_dom( $jd );

print julian_date_format( $jd ) . "\n";

my $dow = julian_date_get_dow( $jd );

print( ( qw( Mon Tue Wed Thu Fri Sat Sun ) )[ $dow ] . "\n" );

my $mdays = julian_date_month_days( $jd );

print "mdays ( $mdays )\n";

my $mdays = julian_date_month_days_ym( $y, $m );

print "mdays ( $mdays )\n";

my $jd = julian_date_to_iso( julian_date_from_ymd( 2022 ) );

print "julian_date_from_ymd( 2022 ): $jd\n";

my $jd = julian_date_to_iso( julian_date_from_md( 10, 11 ) );

print "julian_date_from_md( mm, dd ): $jd\n";


##############################################################################

# taken from DECOR https://github.com/cade-vs/perl-decor
sub utime_format
{
  my $data = shift;
  my $tz   = shift;
 
  my @t = localtime( int( $data ) );
 
  return strftime( "%Y.%m.%d %H:%M:%S %z %Z", @t, $tz );
}

# taken from DECOR https://github.com/cade-vs/perl-decor
sub julian_date_format
{
  my $data = shift;
 
  my ( $y, $m, $d ) = inverse_julian_day( $data );

  my @t = ( undef, undef, undef, $d, $m - 1, $y - 1900 );

  return strftime( "%Y.%m.%d", @t );
}

##############################################################################
