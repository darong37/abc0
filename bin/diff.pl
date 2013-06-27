#!/usr/bin/perl
use strict;
use warnings;

my ( $src,$upd ) = @ARGV;

open SRC,"<",$src or die "not found '$src'";
open UPD,"<",$upd or die "not found '$upd'";

my %h;
my ( $oldver,$updver ) = ( 'n/a','n/a' );
while(<SRC>){
  chomp;
  next if /^\s*$/;
  
  s/^# Version : /Version # /;
  s/\s+/ /g;
  my ( $key,$val ) = split / # /;
  if ( $key eq 'Version' ){
    $oldver = $val;
  } else {
    # keyの先頭フォルダの'.'以下は無視する
    # $key =~ s{^([^/.\s]+)\.[^/\s]+}{$1};
    
    $h{$key} = $val;
  }
}
close SRC;

while(<UPD>){
  chomp;
  next if /^\s*$/;

  s/^# Version : /Version # /;
  s/\s+/ /g;
  my ( $key,$val ) = split / # /;
  if ( $key eq 'Version' ){
    $updver = $val;
  } else {
    # keyの先頭フォルダの'.'以下は無視する
    # $key =~ s{^([^/.\s]+)\.[^/\s]+}{$1};
    
    if ( exists $h{$key} ) {
      if ( $h{$key} eq $val ){
        delete $h{$key};
      } else {
        my @ele1 = split /\s+/ ,$h{$key};
        my @ele2 = split /\s+/ ,$val;
        my $eln = $#ele1;
        if ( $eln < 6 ) {
            # permition が異なる
            $h{$key} = "chg perm";
        } else {
          if ( $ele1[6] ne $ele2[6] ) {
            # cksum が異なる
            if ( "$ele1[0] $ele1[1] $ele1[2]" ne "$ele2[0] $ele2[1] $ele2[2]" ){
              # さらにpermission が異なる
              $h{$key} = "mod+perm";
            } else {
              $h{$key} = "modified";
            }
          } else {
            if ( "$ele1[0] $ele1[1] $ele1[2]" ne "$ele2[0] $ele2[1] $ele2[2]" ){
              # permission が異なる
              $h{$key} = "chg perm";
            } else {
              $h{$key} = "chg date";
            }
          }
        }
      }
    } else {
      $h{$key} = "new file";
    }
  }
}
close UPD;
#
# Results
#
my $dcnt;
if ( $oldver eq $updver ){
  $dcnt = 0;
  print "\n";
  print "    Version      $updver\n\n";
} else {
  $dcnt = 1;
  print "\n";
  print "    Version      $oldver  ->  $updver\n\n";
}
for my $key ( sort keys %h){
  $dcnt++;
  my $val = $h{$key};
  $h{$key} = "deleted " if $val !~ /new file|modified|mod\+perm|chg perm|chg date/;
  
  printf "    %s:    %s\n",$h{$key},$key;
}

if ( $dcnt == 0 ){
  print "\n";
  print "    identified\n";
  exit
} else {
  print "\n";
  print "    different\n";
  exit 1
} 
