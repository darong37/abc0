#!/bin/perl
use Prompt::Timeout;

my $ans = prompt ( "question", "deafult", 5 );
printf "Ans: '$ans'\n";

