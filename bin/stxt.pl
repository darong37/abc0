#!/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin";
use stxt;

#
my $stxt = Stxt -> new('/c/Users/JKK0544/.abc/logs/oper/20130812/20130812-002_oracle-check-tablespaces-size_orae058@mecerp3x0111.txt');

$stxt -> read;

my @cmds = @{ $stxt->{'cmds'} };
print $cmds[0];

