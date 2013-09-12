#!/bin/perl
use Term::Prompt;

#my $ans = prompt('x', 'question', 'help', 'default' );
my $ans = prompt('x', 'question ?','','' );
printf "Ans: '$ans'\n";

$ans = prompt('x', 'question ?','y/n','' );
printf "Ans: '$ans'\n";

$ans = prompt('x', 'question ?','y/n','y' );
printf "Ans: '$ans'\n";

$ans = prompt('x', 'question ?','','y' );
printf "Ans: '$ans'\n";

