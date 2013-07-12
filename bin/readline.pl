#!/bin/perl
use Term::ReadLine;
$term = new Term::ReadLine 'my_term';
$prompt = "input :";
$OUT = $term->OUT || STDOUT;
while ( defined ($_ = $term->readline($prompt)) ) {
  print $OUT "output:$_\n";
  $term->addhistory($_) if /\S/;
}
