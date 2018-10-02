#!/usr/bin/perl
use strict;
use warnings;

sub merge {
    my ($s, @b) = @_;
    my @a = splice @b, $s;

    return @a, @b unless @a && @b;
    my $head = $a[0] < $b[0] ? shift @a : shift @b;
    return $head, merge(scalar @a, @a, @b);
}

sub mergesort {
    my $half = int(@_ / 2);
    return @_ unless $half;

    return merge($half, mergesort(splice @_, $half), mergesort(@_));
}

my @sorted = mergesort(10, 9, 8, 4, 5, 6, 7, 3, 2, 1);
print "@sorted\n";
