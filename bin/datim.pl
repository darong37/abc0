#!/bin/perl
use strict;
use warnings;
use DateTime;

my $dt = DateTime->now;
print $dt->year, "\n";
print $dt->strftime('%Y-%m-%d %H:%M:%S'), "\n";

