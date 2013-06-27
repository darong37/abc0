#!/bin/perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);

$Term::ANSIColor::AUTORESET = 1;

### Arguments
my ( $ptnFil, $tgtFil ) = @ARGV;

### Target File
open TGT,"<$tgtFil" or die "not found '$tgtFil'";
  $/ = undef;
  my $src = <TGT>;
close TGT;

### Pattern File
$/ = "\n";
open PTN,"<$ptnFil" or die "not found '$ptnFil'";

### Seqensial Matching
my $qmode = 'on';
my $cnt=0;
my $regex = '';
my $match;
my @eles;
while(<PTN>){
  chomp;
  my $raw = $_;
  $cnt++;
  
  #
  # Q-mode
  #
#  if ( /^\s*\{\s*$/ ){
#    $qmode = 'off';
##   printf "%04d:%-3s: '%s'\n" ,$cnt,$qmode,$raw;
#    next;
#  }
#  if ( /^\s*\}\s*$/ ){
#    $qmode = 'on';
##   printf "%04d:%-3s: '%s'\n" ,$cnt,$qmode,$raw;
#    next;
#  }
  ( $qmode = 'off',next ) if /^\s*\{\s*$/;
  ( $qmode = 'on' ,next ) if /^\s*\}\s*$/;
  
  my $ptn;
  if ( $qmode eq 'on' ){
    # '{(' start REGEX.
    s/\{\(/\\E\(/g;

    # ')}' end REGEX.
    s/\)\}/\)\\Q/g;

    $ptn    = '\Q'.$_.'\E\n';
    $regex .= '\Q'.$_.'\E\n';
  } else {
    $ptn    = $_;
    $regex .= $_;
  }
  
  $match = 'NG';
  $match = 'OK' if eval "\$src =~ m{${regex}}";
#  if ( @eles =  ( eval "\$src =~ m{(${regex})}" ) ){
#    $match = 'OK';
#  } else {
#    $match = 'NG';
#  }

  if ( $match eq 'OK' ) {
    @eles =  ( eval "\$src =~ m{(${regex})}" );
  } else {
    print BLUE "$eles[0]";
    print RED  "$ptn\n";
    print "\n## Elements ##\n";
    shift @eles;
    $cnt=1;
    for my $ele ( @eles ){
      printf "%02d: '%s'\n",$cnt++,$ele;
    }
    last;
  }
};
close PTN;

if ( $match eq 'OK' ) {
  @eles =  ( eval "\$src =~ m{(${regex})}" );
  print BLUE "$eles[0]";
  shift @eles;
  $cnt=1;
  for my $ele ( @eles ){
    printf "%02d: '%s'\n",$cnt++,$ele;
  }
}
