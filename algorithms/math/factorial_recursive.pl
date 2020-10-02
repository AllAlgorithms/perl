#! /usr/bin/env perl

use strict;
use warnings;

sub factorial
{
	my( $n ) = @_;

	return ( $n <= 0 ) ? 1 : $n * factorial( $n - 1 );
}

MAIN:
	my $n = $ARGV[0];
	print( "$n! = " . factorial( $n ) . "\n" );

__END__
