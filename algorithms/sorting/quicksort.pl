#!/usr/bin/perl
# Based on Cormen third edition
use strict;
use warnings;

sub quicksort (\@) {qsort($_[0], 0, $#{$_[0]})}

sub qsort{
    my ($aref, $p, $r) = @_;
    
    if($p < $r){
        my $q = partition($aref, $p, $r);
        qsort($aref, $p, $q - 1);
        qsort($aref, $q + 1, $r);
    }
}

sub partition{
    my ($aref, $p, $r) = @_;
    my $x = $aref->[$r];
    my $i = $p - 1;
    
    for my $j($p .. $r - 1){
        if($aref->[$j] <= $x){
            $i++;
            ($aref->[$i], $aref->[$j]) = ($aref->[$j], $aref->[$i]);
        }
    }
    
    ($aref->[$i + 1], $aref->[$r]) = ($aref->[$r], $aref->[$i + 1]);
    return $i + 1;
}

my @array = (9, 8, 4, 5, 6, 7, 3, 2, 1);

quicksort @array;
print "@array\n";
