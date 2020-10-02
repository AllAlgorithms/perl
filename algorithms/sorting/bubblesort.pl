use strict;
use warnings;

sub bubble_sort {
	my @a = @_;

	my $n = scalar @a;
	for (my $j = 1; $j <= $n; $j++) {
		my $f = 0;
		my $min = $j;
		for (my $i = $j; $i <= $n-$j; $i++) {
			if ($a[$i-1] > $a[$i]) {
				($a[$i-1], $a[$i]) = ($a[$i], $a[$i-1]);
				$f = 1;
			}
			$min = $i-1 if ($a[$i-1] < $a[$min]);
		}
		last if $f == 0;
		($a[$j-1], $a[$min]) = ($a[$min], $a[$j-1]) if ($min != $j);
	}
    return @a;
}

my @sorted = bubble_sort ( qw/10 9 8 4 5 6 7 3 2 1/ );
print "@sorted\n";
