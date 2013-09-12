#!/bin/perl
use strict;
use IO::Prompt::Simple;

##
sub input {
  my $ans = prompt @_;
  printf "\nans: '$ans'\n";
  return $ans;
}
##
my $TIMEOUT = 5;

#print "What your name > ";
my $name = 'hoge';
eval {
  local $SIG{ALRM} = sub {die};
  alarm($TIMEOUT);
# $name = prompt "What your name > " ;
  $name = input "What your name > " ;
  my $timeleft = alarm(0);
};

if ($@) {
  # タイムアウト
  print "\nERROR: TIMEOUT\n";
  print "Hello! $name";
}else{
# 正常終了
  print "Hello! $name";
}


