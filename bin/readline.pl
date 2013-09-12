#!/bin/perl
use Term::ReadLine;
#use IO::Prompt::Simple;
use FindBin;
use lib "$FindBin::Bin";
use eyos;

$term = new Term::ReadLine 'my_term';
$prompt = "input :";
#$OUT = $term->OUT || STDOUT;
$OUT = STDOUT;
while ( defined ($_ = $term->readline($prompt)) ) {
  print {$OUT} "output:$_\n";
# my $ans = prompt 'dou ? ';
  my $ans = input 'dou ? ';
  print {$OUT} "answer:$ans\n";
  
  $term->addhistory($_) if /\S/;
}
