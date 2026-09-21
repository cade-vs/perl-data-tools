#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Time;

for( -200, -100, 50, 120, 300 )
  {
  my $ds = julian_date_diff_in_words( $_ );
  my $dr = julian_date_diff_in_words_relative( $_ );
  my $dd = str_pad( $_, -10 );
  my $dr_bg = trans_to_bg( $dr );
  print "($dd) $ds | $dr | $dr_bg\n";
  }



for( -20000, -10000, 500, 50, 125, 250, 300, 400000 )
  {
  my $ts = unix_time_diff_in_words( $_ );
  my $tr = unix_time_diff_in_words_relative( $_ );
  my $tt = str_pad( $_, -10 );
  my $tr_bg = trans_to_bg( $tr );
  print "($tt) $ts | $tr | $tr_bg\n";
  }

sub trans_to_bg
{
  my $s = shift;
  
  my %TRANS = (
              'now'       => 'sega',
              'today'     => 'dnes',
              'tomorrow'  => 'utre',
              'yesterday' => 'vchera',
              'in'        => 'sled',
              'before'    => 'predi',
              'year'      => 'godina',
              'years'     => 'godini',
              'month'     => 'mesec',
              'months'    => 'meseca',
              'day'       => 'den',
              'days'      => 'dni',
              'hour'      => 'chas',
              'hours'     => 'chasa',
              'minute'    => 'minuta',
              'minutes'   => 'minuti',
              'second'    => 'sekunda',
              'seconds'   => 'sekundi',
              );
              
  $s =~ s/([a-z]+)/$TRANS{ lc $1 } || $1/ge;
  
  return $s;
}
