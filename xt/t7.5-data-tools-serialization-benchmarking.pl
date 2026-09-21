#!/usr/bin/perl
##############################################################################
#
#  Data::Tools test suite -- Data::Tools::Serialization benchmark
#  Copyright (c) 2013-2026 Vladi Belperchinov-Shabanski "Cade"
#        <cade@noxrun.com> <cade@bis.bg> <cade@cpan.org>
#  http://cade.noxrun.com/
#
#  GPL
#
##############################################################################
#
#  SERIALIZATION BENCHMARK -- INFORMATION ONLY
#
#  This file asserts nothing beyond a single module load check. The benchmark
#  runs after done_testing() and is wrapped in eval(), including the driver
#  itself, so it can never fail the test suite under any circumstance.
#
#  Per method the report shows:
#    n/a     -- the module this method needs is not installed
#    error   -- encoding or decoding died, or produced nothing
#    skipped -- a single iteration already blew the time budget at a smaller
#               size, larger sizes are not attempted so installs do not stall
#
#  Only encode/decode success is checked, not round trip equality: the XML
#  methods do not reproduce the original perl structure verbatim by design.
#
#  The iteration and time budget are the two variables at the top of
#  bench_run() below.
#
##############################################################################
use strict;
use lib 'lib', '../lib';
use Test::More;
use Data::Tools::Serialization;

ok( defined $Data::Tools::Serialization::VERSION, 'Data::Tools::Serialization loaded' );

done_testing();

##############################################################################

eval { bench_run(); 1 } or diag( "benchmark skipped: $@" );

##############################################################################

sub bench_methods
{
  return (
    {
      name   => 'json (perl2json)',
      module => 'JSON',
      pack   => sub { return perl2json( shift ) },
      unpack => sub { return json2perl( shift ) },
    },
    {
      name   => 'xml (perl2xml)',
      module => 'XML::Bare',
      pack   => sub { return perl2xml( shift ) },
      unpack => sub { return xml2perl( shift ) },
    },
    {
      name   => 'storable (ref_freeze)',
      module => 'Storable',
      pack   => sub { return Data::Tools::ref_freeze( shift ) },
      unpack => sub { return Data::Tools::ref_thaw( shift ) },
    },
    {
      name   => 'hash2str',
      module => undef,
      pack   => sub { return Data::Tools::hash2str( shift ) },
      unpack => sub { return Data::Tools::str2hash( shift ) },
    },
    {
      name   => 'hash2str_url',
      module => undef,
      pack   => sub { return Data::Tools::hash2str_url( shift ) },
      unpack => sub { return Data::Tools::str2hash_url( shift ) },
    },
    {
      name   => 'sereal',
      module => 'Sereal',
      pack   => sub { return Sereal::encode_sereal( shift ) },
      unpack => sub { return Sereal::decode_sereal( shift ) },
    },
    {
      name   => 'stacker',
      module => 'Data::Stacker',
      pack   => sub { return Data::Stacker::stack_data( shift ) },
      unpack => sub { return Data::Stacker::unstack_data( shift ) },
    },
    {
      name   => 'xml::simple',
      module => 'XML::Simple',
      pack   => sub { return XML::Simple::XMLout( shift ) },
      unpack => sub { return XML::Simple::XMLin( shift ) },
    },
  );
}

# a flat hash of plain strings -- the only shape every method here can handle,
# hash2str() and friends do not serialize nested structures
sub bench_make_data
{
  my $target = shift; # wanted approximate raw data size in bytes

  my %hash;
  my $size = 0;
  my $n    = 0;

  while( $size < $target )
    {
    my $k = sprintf( 'key%08d', $n );
    my $v = "value $n " . ( 'x' x 24 );
    $hash{ $k } = $v;
    $size += length( $k ) + length( $v ) + 2;
    $n++;
    }

  return ( \%hash, $size, $n );
}

sub bench_have_module
{
  my $module = shift;

  return 1 unless $module;
  eval { my $fn = Data::Tools::perl_package_to_file( $module ); require $fn; 1 } or return 0;
  return 1;
}

# runs $code as many times as it can within the iteration and time budget,
# returns the last result, the number of iterations done and the elapsed time
sub bench_timed
{
  my $code  = shift;
  my $arg   = shift;
  my $iters = shift; # max iterations
  my $secs  = shift; # max seconds

  my $res;
  my $done  = 0;
  my $start = Time::HiRes::time();
  my $spent = 0;

  while( 1 )
    {
    $res = $code->( $arg );
    $done++;
    $spent = Time::HiRes::time() - $start;
    last if $done >= $iters or $spent >= $secs;
    }

  return ( $res, $done, $spent );
}

sub bench_rate
{
  my $done  = shift;
  my $spent = shift;

  return '-' unless $spent > 0;

  my $rate = $done / $spent;
  return sprintf( '%.1f', $rate ) if $rate < 10;
  return sprintf( '%.0f', $rate );
}

sub bench_run
{
  require Data::Tools;
  require Time::HiRes;

  my $MAX_ITERS = 1_000; # iterations per single measurement
  my $MAX_SECS  = 3;     # seconds per single measurement, whichever comes first

  my @SIZES = (
              { name => '1K',   bytes =>     1_000 },
              { name => '500K', bytes =>   500_000 },
              { name => '1M',   bytes => 1_000_000 },
              );

  diag( "\nBENCHMARKING IN PROGRESS\n" );

  my @methods = bench_methods();
  my %slow;
  my @sizes_note;

  my @rows;
  push @rows, [ '<', '<', '>', '>', '>', '>', '>' ];
  push @rows, [ 'DATA', 'METHOD', 'ENCODED', 'ENCODE ms', 'ENCODE/s', 'DECODE ms', 'DECODE/s' ];

  for my $size ( @SIZES )
    {
    my ( $data, $raw_size, $keys ) = bench_make_data( $size->{ 'bytes' } );
    push @sizes_note, "$size->{ 'name' } = $keys keys, $raw_size bytes raw";

    for my $m ( @methods )
      {
      my $name = $m->{ 'name' };

      if( ! bench_have_module( $m->{ 'module' } ) )
        {
        push @rows, [ $size->{ 'name' }, $name, 'n/a', '-', '-', '-', '-' ];
        next;
        }

      if( $slow{ $name } )
        {
        push @rows, [ $size->{ 'name' }, $name, 'skipped', '-', '-', '-', '-' ];
        next;
        }

      # encode
      my ( $encoded, $edone, $espent );
      my $eok = eval { ( $encoded, $edone, $espent ) = bench_timed( $m->{ 'pack' }, $data, $MAX_ITERS, $MAX_SECS ); 1 };

      if( ! $eok or ! defined $encoded or $encoded eq '' )
        {
        push @rows, [ $size->{ 'name' }, $name, 'error', '-', '-', '-', '-' ];
        next;
        }

      # a single iteration already blew the time budget, do not try bigger data
      $slow{ $name }++ if $edone == 1 and $espent > $MAX_SECS;

      # decode
      my ( $decoded, $ddone, $dspent );
      my $dok = eval { ( $decoded, $ddone, $dspent ) = bench_timed( $m->{ 'unpack' }, $encoded, $MAX_ITERS, $MAX_SECS ); 1 };

      if( ! $dok or ! defined $decoded )
        {
        push @rows, [
                    $size->{ 'name' },
                    $name,
                    length( $encoded ),
                    sprintf( '%.3f', 1000 * $espent / $edone ),
                    bench_rate( $edone, $espent ),
                    'error',
                    '-',
                    ];
        next;
        }

      $slow{ $name }++ if $ddone == 1 and $dspent > $MAX_SECS;

      push @rows, [
                  $size->{ 'name' },
                  $name,
                  length( $encoded ),
                  sprintf( '%.3f', 1000 * $espent / $edone ),
                  bench_rate( $edone, $espent ),
                  sprintf( '%.3f', 1000 * $dspent / $ddone ),
                  bench_rate( $ddone, $dspent ),
                  ];
      }
    }

  diag( "\nserialization benchmark (information only, never fails)\n"
      . "each measurement runs up to $MAX_ITERS iterations or $MAX_SECS seconds, whichever comes first\n"
      . "ms is per single encode/decode of the whole structure, /s is encodes/decodes per second\n"
      . join( "\n", map { "  $_" } @sizes_note ) . "\n\n"
      . Data::Tools::format_ascii_table( \@rows, FMT => 1 ) );

  return 1;
}

##############################################################################
