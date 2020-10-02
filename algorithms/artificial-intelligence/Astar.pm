#!/usr/bin/env perl
package Astar;    # A*: https://en.wikipedia.org/wiki/A*_search_algorithm
use strict;        # MinPQ: https://algs4.cs.princeton.edu/24pq/
use Exporter qw< import >;
our @EXPORT_OK = qw< astar >;

=pod

=head1 SYNOPSIS

   use Astar qw< astar >;

   # Arguments, M for Mandatory, O for Optional
   my %args = (
      start      => $node1, # M, node in your graph
      goal       => $node2, # M, node in your graph
      distance   => \&dsub, # M, subref, takes 2 nodes, returns number
      successors => \&ssub, # M, subref, takes 1 node, returns nodes list
      heuristic  => \&dsub, # O, subref like distance, defaults to distance
      identifier => \&dsub, # O, subref, takes 1 node, returns id,
                            #    defaults to stringification of input node
   );

   # get a list back
   @path = astar(%args);
   @path = astar(\%args); # works with reference to hash too

   # get an array reference back, containing the list above
   $path = astar(%args);
   $path = astar(\%args); # works with reference to hash too

=cut

sub astar {
   my %args = (@_ && ref($_[0])) ? %{$_[0]} : @_;
   my @reqs = qw< start goal distance successors >;
   exists($args{$_}) || die "missing parameter '$_'" for @reqs;
   my ($start, $goal, $dist, $succs) = @args{@reqs};
   my $h     = $args{heuristic}  || $dist;
   my $id_of = $args{identifier} || sub { return "$_[0]" };

   my ($id, $gid) = ($id_of->($start), $id_of->($goal));
   my %node_for = ($id => {value => $start, g => 0});
   my $queue = bless ['-', {id => $id, f => 0}], __PACKAGE__;

   while (!$queue->_is_empty) {
      my $cid = $queue->_dequeue->{id};
      my $cx  = $node_for{$cid};
      next if $cx->{visited}++;

      my $cv = $cx->{value};
      return __unroll($cx, \%node_for) if $cid eq $gid;

      for my $sv ($succs->($cv)) {
         my $sid = $id_of->($sv);
         my $sx = $node_for{$sid} ||= {value => $sv};
         next if $sx->{visited};
         my $g = $cx->{g} + $dist->($cv, $sv);
         next if defined($sx->{g}) && ($g >= $sx->{g});
         @{$sx}{qw< p g >} = ($cid, $g);    # p: id of best "previous"
         $queue->_enqueue({id => $sid, f => $g + $h->($sv, $goal)});
      } ## end for my $sv ($succs->($cv...))
   } ## end while (!$queue->_is_empty)

   return;
} ## end sub astar

# Functions implementing a minimal priority queue
sub _dequeue {                              # includes "sink"
   my ($k, $self) = (1, @_);
   my $r = ($#$self > 1) ? (splice @$self, 1, 1, pop @$self) : pop @$self;
   while ((my $j = $k * 2) <= $#$self) {
      ++$j if ($j < $#$self) && ($self->[$j + 1]{f} < $self->[$j]{f});
      last if $self->[$k]{f} < $self->[$j]{f};
      (@{$self}[$j, $k], $k) = (@{$self}[$k, $j], $j);
   }
   return $r;
} ## end sub _dequeue

sub _enqueue {                              # includes "swim"
   my ($self, $node) = @_;
   push @$self, $node;
   my $k = $#$self;
   (@{$self}[$k / 2, $k], $k) = (@{$self}[$k, $k / 2], int($k / 2))
     while ($k > 1) && ($self->[$k]{f} < $self->[$k / 2]{f});
} ## end sub _enqueue

sub _is_empty { return !$#{$_[0]} }

sub __unroll {    # unroll the path from start to goal
   my ($node, $node_for, @path) = ($_[0], $_[1], $_[0]{value});
   while (defined(my $p = $node->{p})) {
      $node = $node_for->{$p};
      unshift @path, $node->{value};
   }
   return wantarray ? @path : \@path;
} ## end sub __unroll


########################################################################
#
# What follows is just to show an example usage of astar and can be
# ignored if using this implementation as a module.
#
########################################################################

sub __example_get_field {
   my $field_text = <<'END_OF_FIELD';
###################
#     #        #  #
#  #  #  #     # X#
#  #  #  #  #  #  #
#@ #     #  #  #  #
#  #  #  #  #  #  #
#  #  #     #  #  #
#     #  #  #     #
###################
END_OF_FIELD
   my ($player, $target, @field);
   for my $line (split m{\s*\n}mxs, $field_text) {
      push @field, [split m{}mxs, $line];
      for my $j (0 .. $#{$field[-1]}) {
         my $c = $field[-1][$j];
         if ($c eq '@') {
            $player = [$#field, $j];
         }
         elsif ($c eq 'X') {
            $target = [$#field, $j];
         }
      }
   }
   return ($player, $target, \@field);
}

sub __example_distance {
   my ($x, $y) = map { $_->{pos} } @_;
   return abs($x->[0] - $y->[0]) + abs($x->[1] + $y->[1]);
}

sub __example_identifier {
   my $x = $_[0]{pos};
   return "($x->[0], $x->[1])";
}

sub __example_successors {
   my ($I, $J, $field) = (@{$_[0]{pos}}, $_[0]{field});
   my @retval;
   for my $i ($I - 1 .. $I + 1) {
      next if $i < 0 || $i > $#$field;
      for my $j ($J - 1 .. $J + 1) {
         next if ($i == $I) && ($j == $J); # avoid same position
         next if $j < 0 || $j > $#{$field->[$i]};
         next if $field->[$i][$j] eq '#';
         push @retval, {
            pos => [$i, $j],
            field => $field,
         };
      }
   }
   return @retval;
}

sub __example_print_field {
   my ($field) = @_;
   for my $line (@$field) {
      print {*STDOUT} join('', @$line), "\n";
   }
}

sub __MAIN {
   my ($player, $target, $field) = __example_get_field();

   # Arguments, M for Mandatory, O for Optional
   my %args = (
      start      => { pos => $player, field => $field },
      goal       => { pos => $target, field => $field },
      distance   => \&__example_distance,
      successors => \&__example_successors,
      identifier => \&__example_identifier,
   );

   my @path = astar(%args);

   print {*STDOUT} "initial field (\@: player, X: target):\n";
   __example_print_field($field);

   shift @path; # first position in path is player's position
   pop @path;   # last position is target's position
   my $char = 1;
   for my $step (@path) {
      my ($i, $j) = @{$step->{pos}};
      $field->[$i][$j] = $char;
      if ($char ne '.') {
         ++$char;
         $char = '.' if $char > 3;
      }
   }
   print {*STDOUT} "\nfield with path (1, 2, 3, ...):\n";
   __example_print_field($field);
}

########################################################################
#
# Restrict running MAIN only to when this file is executed, not when
# it is "use"-d or "require"-d, according to the "Modulino" trick.
#
# See https://gitlab.com/polettix/notechs/snippets/1868370

exit sub {
   __MAIN(@_);
   return 0;
}->(@ARGV) unless caller;

1;
