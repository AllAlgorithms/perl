#!/usr/bin/env perl
use strict;
use warnings;

# $index = binary_search( \@array, $word )
#   @array is a list of lowercase strings in alphabetical order.
#   $word is the target word that might be in the list.
#   binary_search() returns the array index such that $array[$index]
#   is $word.

my @names_list = qw (anatole barnabe dalida johnny mickael sally zazie);
my $name_to_find = 'dalida';
print binary_search( \@names_list, $name_to_find );

sub binary_search {
  my ($array, $word) = @_;
  my ($start, $end)  = ( 0, @$array - 1 );
  my $mid;

  while ( $start <= $end ){
    $mid = int( ($start+$end)/2 );    # Get the middle value
    if ($array->[$mid] eq $word){     # Check if that value is the correct one
      return $mid;                    # Word found
    }
    else {
      if ( $word gt $array->[$mid] ){
        $start = $mid + 1;            # Raise the start value 
      }
      else {
        $end = $mid - 1;              # Lower the end value
      }
    }
  }
  return;                             # Word not found
}