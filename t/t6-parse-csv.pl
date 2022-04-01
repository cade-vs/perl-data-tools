#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools::CSV;
use Data::Dumper;

my $csv = <<END;
TEST,IS,HERE,NOPE,THERE
123,is,testing,"""The"" book, is now",qwerty
"1997","Ford","E350"
1997,Ford,E350,"Super, ""luxurious"" truck"
END

print Dumper( parse_csv( $csv ) );
print Dumper( parse_csv_to_hash_array( $csv ) );
