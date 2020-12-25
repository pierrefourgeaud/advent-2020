use warnings;
use strict;
use feature 'say';

my @input;

while (<STDIN>) {
    chomp;
    push @input, $_;
}

sub count_trees {
  my $input = ($_[0]);
  my $right = $_[1];
  my $down = $_[2];
  my $idx = $down;
  my $trees = 0;
  my $current_right = $right;

  while ($idx < scalar(@$input)) {
    my @line = split("", @$input[$idx]);
    if (@line[$current_right % scalar(@line)] eq '#') {
      $trees++;
    }
    $idx += $down;
    $current_right += $right;
  }

  return $trees;
}

my $r1d1 = count_trees(\@input, 1, 1);
my $r3d1 = count_trees(\@input, 3, 1);
my $r5d1 = count_trees(\@input, 5, 1);
my $r7d1 = count_trees(\@input, 7, 1);
my $r1d2 = count_trees(\@input, 1, 2);
say("Part 1: ", $r3d1);
say("Part 2: ", $r1d1 * $r3d1 * $r5d1 * $r7d1 * $r1d2);