use strict;
use warnings;

sub in_sort {
    my @a = @_;

    for (my $i = 1; $i <= $#a; $i++) {
        my $n = $i;
        while ($a[$n] < $a[$n-1] && $n > 0) {
            ($a[$n-1], $a[$n]) = ($a[$n], $a[$n-1]);
            $n--;
        }
    }
    return @a;
}

my @sorted = in_sort ( qw/10 9 8 4 5 6 7 3 2 1/ );
print "@sorted\n";
