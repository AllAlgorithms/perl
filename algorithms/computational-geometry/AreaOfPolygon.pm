#!/usr/bin/env perl
package AreaOfPolygon;
use strict;
use Exporter qw< import >;
our @EXPORT_OK = qw< polygon_area polygon_area_signed >;

=pod

=head1 SYNOPSIS

   use AreaOfPolygon qw< polygon_area polygon_area_signed >;

   my @cw_poly = ( [0, 1], [1, 0], [0, -1], [-1, 0], [0, 1]);

   my $signed_area_cw  = polygon_area_signed(@cw_poly);
   my $signed_area_ccw = polygon_area_signed(reverse @cw_poly);
   die unless abs($signed_area_cw + $signed_area_ccw) < 1e-10;

   my $area_cw  = polygon_area(@cw_poly);
   my $area_ccw = polygon_area(reverse @cw_poly);
   die unless abs($area_cw - $area_ccw) < 1e-10;

=cut

# Input vertices are supposed to be given in order, with the first one
# being the same as the last one to close the polygon. Each vertex is
# provided as a reference to an array of two elements. The result can be
# positive or negative depending on the ordering of vertices.
sub polygon_area_signed {
   my $sum = 0;
   $sum += $_[$_][0] * $_[$_ + 1][1] - $_[$_ + 1][0] * $_[$_][1]
      for 0 .. $#_ - 1;
   return $sum / 2;
}

# Same as polygon_area_signed
sub polygon_area { return abs(polygon_area_signed(@_)) }


########################################################################
#
# What follows is just to show an example usage of the different subs
# and is ignored if using this implementation as a module.
#
########################################################################

sub __MAIN {
   if (! defined $_[0]) {
      print {*STDERR} "$0 vertices...\n";
      return 1;
   }
   my @poly = map { [ split m{,}mxs ] } @_;
   print {*STDOUT} polygon_area_signed(@poly), "\n";
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
