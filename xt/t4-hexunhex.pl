#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Time;
use Time::HiRes qw( time );
use Encode;
use utf8;

binmode( STDOUT, ':utf8' );

my $text = substr( file_bin_load( '/tmp/big.txt' ), 0, 1024 );

my $cnt = 142;
my $hex;

my $s = time;
$hex = str_hex( $text ) for 1..$cnt;
my $e = time() - $s;
print ( str_num_comma( $cnt / $e ) . " cps\n" );

=pod
my $s = time;
$hex = Data::Tools::str_hex2( $text ) for 1..$cnt;
my $e = time() - $s;
print ( str_num_comma( $cnt / $e ) . " cps\n" );

#print Data::Tools::str_hex( $text ). "\n";
#print Data::Tools::str_hex2( $text ). "\n";

print "YES OK 1\n" if Data::Tools::str_hex2( $text ) eq Data::Tools::str_hex( $text );
=cut

$hex = uc $hex;
#print "HEX[$hex]\n\n";


my $s = time;
my $text = Data::Tools::str_unhex( $hex ) for 1..$cnt;
my $e = time() - $s;
print ( str_num_comma( $cnt / $e ) . " cps\n" );

=pod
my $s = time;
my $text = Data::Tools::str_unhex2( $hex ) for 1..$cnt;
my $e = time() - $s;
print ( str_num_comma( $cnt / $e ) . " cps\n" );

#print Data::Tools::str_unhex( $hex ). "\n";
#print Data::Tools::str_unhex2( $hex ). "\n";

print "YES OK 2\n" if Data::Tools::str_unhex( $hex ) eq Data::Tools::str_unhex2( $hex );
=cut


my $str = "Това е проста проба";
print "str is utf8\n" if Encode::is_utf8( $str );
print "str [$str]\n";

$str = encode( 'UTF-8', $str );
print "str encoded to utf8 is NOT utf8\n" if ! Encode::is_utf8( $str );
print "asc [$str]\n";

my $hex = str_hex( $str );
print "hex [$hex]\n";
print "str len: " . length($str) . "\n";
print "hex len: " . length($hex) . "\n";

$str = decode( 'UTF-8', str_unhex( $hex ) );
print "str [$str]\n";
print "str len: " . length($str) . "\n";
