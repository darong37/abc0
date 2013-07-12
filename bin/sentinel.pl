#!/bin/perl
use strict;
use warnings;

#open my $fh,'< a.txt' or die 'open error';
#my $cur=<$fh> || die 'empty';
#while ( my $nxt=<$fh> || '### sentinel ###') {
#  print "$cur";
#
# last if $nxt eq '### sentinel ###';
#  $cur = $nxt;
#}
#close $fh;

##=comment
sub openR(&@){
  my ( $blocks,$rfn,$sen ) = @_;
  $sen |= '#EOF#';
  
  our $openRcount = 0;
  open my $rfh,"< $rfn" or return 0;
  
  my $cur=<$rfh> || return 0;
  while ( our $openRnext=<$rfh> || $sen) {
    $openRcount++;
    $_ = $cur;
    $blocks->();
    
#   last if $nxt eq $sen;
    last if $cur eq $sen;
    $cur = $openRnext;
  }
  close $rfh;
}
##=out

openR{
  if ( our $openRnext =~ /^-/ ){
    $openRnext =~ s/^-/$_/;
  } else {
    my $cnt = our $openRcount;
    print "$cnt:'$_'";
  }
} 'a.txt';
