# Levenshtein distance calculation.
# The Levenshtein distance is a string metric for measuring the difference between two sequences.
# It is the minimum number of single-character edits (insertions, deletions or substitutions),
# required to change one word into the other.

use strict;
use warnings;

sub min {
	my $min = undef;
	for (@_) {
		$min //= $_;
		$min = $_ if ($min > $_);
	}
	return $min;
}

sub levenshtein {
	my ($x, $y) = @_;

	my @A = split //, $x;
	my @B = split //, $y;

	my @W = ( 0..@B );

	my ($cur, $next);

	for my $i ( 0..$#A ) {
		$cur = $i+1;
		for my $j ( 0..$#B ) {
			$next = min (
				$W[$j+1]+1,
				$cur+1,
				( $A[$i] ne $B[$j] ) + $W[$j],
			);
		$W[$j] = $cur;
		$cur = $next;
		}
	$W[@B] = $next;
	}

	return $next;
}

printf ("%d\n", levenshtein("foo", "bar")); # 3
printf ("%d\n", levenshtein("bar", "baz")); # 1
printf ("%d\n", levenshtein("kitten", "sitting")); # 3
