#!/usr/bin/perl

use strict;
use warnings;

my @fib;

die "usage: ./fibonacci_sequence.pl <terms>\n"
    unless scalar @ARGV;
my $terms = shift @ARGV;

my ($n_1, $n_2) = (0, 1);

die "Invalid ``$terms''" if $terms <= 0;
print "0\n" and exit 0 if $terms == 1;

foreach (1 ... $terms) {
    push @fib, $n_1;
    my $n_th = $n_1 + $n_2;
    $n_1 = $n_2;
    $n_2 = $n_th;
}

print join(', ', @fib), "\n";
