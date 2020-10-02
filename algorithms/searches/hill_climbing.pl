#!/usr/bin/env perl
use strict;
use warnings;

# Max Value = hill_climbing($initial_node)
#   @data_set is a list of value with their F(value) result associated.
#   Link to algorithm description in wikipedia: https://en.wikipedia.org/wiki/Hill_climbing


my @data_set = ([1,4],[2,6],[3,15],[4,5],[5,3],[6,2],[7,4],[8,5],[9,6],[10,7],[11,8],[12,10],[13,9],[14,8],[15,7],[16,3]);

my $initial_node = 6;
print "Max Value from starting point $initial_node is ".hill_climbing($initial_node)."\n";


sub hill_climbing {
  my $n = shift;
  my $n_prime;

  while(1){
    $n_prime = select_successor_node($n);
    if (F($n_prime) <= F($n)){
      return $n;
    }
    $n = $n_prime;
  }
}

sub select_successor_node {
  my $current_node = shift;
  my $successor_node;
  my $left_successor = $current_node - 1 if ($current_node - 1) >= 0;
  my $right_successor = $current_node + 1 if ($current_node + 1) <= scalar(@data_set) - 1;
  if (defined $left_successor){
    if (defined $right_successor){
      $successor_node = F($left_successor) < F($right_successor) ? $right_successor : $left_successor;
    }
    else {
      $successor_node = $left_successor;
    }
  }
  else {
    if (defined $right_successor){
      $successor_node = $right_successor;
    }
  }
  return $successor_node;
}

sub F {
  my $entry_value = shift;
  return $data_set[$entry_value-1]->[1];
}