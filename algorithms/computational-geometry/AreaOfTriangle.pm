#!/usr/bin/env perl
package AreaOfTriangle;
use strict;
use Exporter qw< import >;
our @EXPORT_OK = qw< triangle_area_basic triangle_area_cartesian >;

=pod

=head1 SYNOPSIS

   use AreaOfTriangle qw< triangle_area_basic triangle_area_cartesian >;

   my $basic = triangle_area_basic(
      10, # base
      12, # height
   ); # result: 60

   my $planar = triangle_area_cartesian(
      [1, 1],  # vertex A, 2 coordinates
      [11, 1], # vertex B, 2 coordinates
      [1, 13], # vertex C, 2 coordinates
   ); # result: 60

   my $planar_vectorial = triangle_area_cartesian(
      [10, 0], # vector v, 2 coordinates
      [0, 12], # vector w, 2 coordinates
   ); # result: 60

   my $spatial = triangle_area_cartesian(
      [1, 1, 1],   # vertex A, 3 coordinates
      [11, 1, 2],  # vertex B, 3 coordinates
      [1, 13, 15], # vertex C, 3 coordinates
   ); # result: 92.39047...

   my $spatial_vectorial = triangle_area_cartesian(
      [10, 0, 1],  # vector v, 3 coordinates
      [0, 12, 14], # vector w, 3 coordinates
   ); # result: 92.39047...

=cut

sub triangle_area_basic {
   my ($base, $height) = @_;
   return $base * $height / 2;
}

# This combines together into a single access point four variants, derived
# by mixing and matching the following alternatives:
# - provision of three vertices (A, B, and C) or two vectors (v, w)
# - planar (two dimensions) or spatial (three dimensions)
#
# The "vector" alternative can be seen as if A is in the origin and the
# provided inputs are positions of B and C.
sub triangle_area_cartesian {
   my ($A, $B, $C) = @_;
   ref($A) eq 'ARRAY' && (@$A == 2 || @$A == 3) or die "invalid first point";
   ref($B) eq 'ARRAY' && @$B == @$A or die "invalid second point";
   ($A, $B, $C) = ([(0) x @$A], $A, $B) unless defined $C;
   (ref($C) eq 'ARRAY' && @$C == @$A) or die "invalid third point";
   return _triangle_area_plane($A, $B, $C) if @$A == 2;
   my $s = 0;
   $s += _triangle_area_plane([@{$A}[@$_]], [@{$B}[@$_]], [@{$C}[@$_]]) ** 2
      for ([1, 2], [2, 0], [0, 1]);
   return sqrt($s);
}

sub _triangle_area_plane {
    my ($v_x, $v_y) = ($_[1][0] - $_[0][0], $_[1][1] - $_[0][1]);
    my ($w_x, $w_y) = ($_[2][0] - $_[0][0], $_[2][1] - $_[0][1]);
    return ($v_x * $w_y - $v_y * $w_x) / 2;
}


########################################################################
#
# What follows is just to show an example usage of the different subs
# and is ignored if using this implementation as a module.
#
########################################################################


sub __MAIN {
   if (! defined $_[0]) {
      print {*STDERR} "$0 bh <b> <h>\n$0 <A> <B> <C> # or\n$0 <v> <w>\n";
      return 1;
   }
   if ($_[0] eq 'bh') {
      print {*STDOUT} triangle_area_basic(@_[1,2]), "\n";
      return 0;
   }
   for my $item (@_) {
      $item =~ s{[][(){}]}{}gmxs;
      $item = [split m{[,; ]+}mxs, $item];
   }
   print {*STDOUT} triangle_area_cartesian(@_), "\n";
   return 0;
}

########################################################################
#
# Restrict running MAIN only to when this file is executed, not when
# it is "use"-d or "require"-d, according to the "Modulino" trick.
#
# See https://gitlab.com/polettix/notechs/snippets/1868370

exit sub { return __MAIN(@_) }->(@ARGV) unless caller;

1;
