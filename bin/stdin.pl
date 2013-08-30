#!/bin/perl
use FindBin;
use lib "$FindBin::Bin";
use eyos;

my $str;

$/="";
print  "STDIN <<CNTL-D\n";
$str = <STDIN>;
printf "str: %s\n",$str;

print "\n\n";
$str = input 'input';
printf "str: %s\n",$str;

print "\n\n";
$/="\n";
print  "STDIN-2 > ";
$str = <STDIN>;
printf "str: %s\n",$str;

print "\n\n";
$str = inputS 'inputS';
printf "str: %s\n",$str;

print "\n\n";
$str = input 'input';
printf "str: %s\n",$str;

