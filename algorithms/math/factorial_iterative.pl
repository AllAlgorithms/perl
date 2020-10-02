#! /usr/bin/env perl

use strict;
use warnings;

sub factorial
{
	my( $n ) = @_;

	my $r = 1;
	while( 0 < $n )
	{
		$r *= $n;
		--$n;
	}

	return $r;
}

MAIN:
	my $n = $ARGV[0];
	print( "$n! = " . factorial( $n ) . "\n" );

__END__
