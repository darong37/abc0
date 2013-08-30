#!/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin";
use stxt;

#
sub expr {
  my $str = shift;
  $str =~ s/\n/\\n /g;
  if ( length($str) > 120 ){
    $str = substr($str,0,120);
    $str .= ' ...';
  }
  return $str;
}
#
my ( $fn ) = @ARGV;

my $stxt = Stxt -> new($fn);

$stxt -> read;

my $host  = $stxt->{'host'};
my $user  = $stxt->{'user'};
my $logf  = $stxt->{'logf'};
my $sheet = $stxt->{'sheet'};

printf "Host : %s\n",$host;
printf "User : %s\n",$user;
printf "Logf : %s\n",$logf;
printf "Sheet: %s\n",$sheet;

my @cmts = @{ $stxt->{'cmts'} };
my @cmds = @{ $stxt->{'cmds'} };
my @rtns = @{ $stxt->{'rtns'} };
my @nots = @{ $stxt->{'nots'} };

printf "Array:\n";
for( my $idx=0;$idx<@cmds;$idx++ ){
  printf "  No.%d\n",$idx;
  printf "      comment : '%s'\n",&expr($cmts[$idx]);
  printf "      command : '%s'\n",&expr($cmds[$idx]);
  printf "      returns : '%s'\n",&expr($rtns[$idx]);
  printf "      notes   : '%s'\n",&expr($nots[$idx]);
}
