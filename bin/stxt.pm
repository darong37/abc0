#!/bin/perl
package Stxt;

use strict;
use warnings;

# $DB::single = 1 if $cnt > 20;
sub new {
  my $pkg = shift;
  my $stxtFile = shift;
  bless {
    stxt  => $stxtFile,
    host  => '',
    user  => '',
    logf  => '',
    sheet => '',
    cmds  => [],
    rtns  => [],
    cmts  => [],
    nots  => [],
  },$pkg;
}

sub read {
  my $self = shift;
  my $stxtFile =  $self -> {'stxt'};
  #
  open my $stxtH,"< $stxtFile" or die "can not open $stxtFile";
  $/ = undef;
  my $stxt = <$stxtH>;
  close $stxtH;
  
  #
  $stxt =~ s/^[ \t\n]+//;        # 先頭スペース
  $stxt =~ s/[ \t\n]+$//;        # 終端スペース
  $stxt = "\n$stxt\n";           # 先頭終端改行付加

  $stxt =~ s/(?<=\n)\s*\n//g;

  $stxt =~ s/^\n//;              # 先頭改行削除
  $stxt =~ s/\n$//;              # 終端改行削除

  #
  my $host;
  my $user;
  my $logf;
  my $sheet;

  my @cmds;
  my @rtns;
  my @cmts;
  my @nots;

  my $cmd='';
  my $rtn='';
  my $cmt='';
  my $not='';
  for (split /\n/,$stxt){
    s/\r?$//;
    
    # skip
    next if ( /^[>\$]?\s*$/ );
    if ( /^#\@/ ){
      ( $host )  = $_ =~ /^#\@host: (.+)\s*$/  if /^#\@host: /;
      ( $user )  = $_ =~ /^#\@user: (.+)\s*$/  if /^#\@user: /;
      ( $logf )  = $_ =~ /^#\@logf?: (.+)\s*$/ if /^#\@logf?: /;
      ( $sheet ) = $_ =~ /^#\@sheet: (.+)\s*$/ if /^#\@sheet: /;
      next;
    }
    
    # evaluate
    if ( /^[>\$] / ) {
      if ( $cmd ne '' ){
        push @cmds,$cmd;
        push @rtns,$rtn;
        push @cmts,'';
        push @nots,$not;
        $cmd='';
        $rtn='';
        $not='';
      }
      if ( $cmt ne '' ){
        push @cmds,'##';
        push @rtns,'';
        push @cmts,$cmt;
        push @nots,'';
        $cmt='';
      }
      # Command
      s/^[>\$] //g;
      $cmd=$_;
    } elsif ( /^_ / ){
      s/^_ //;
      $cmd .= "\n";
      $cmd .= $_;
    } elsif ( /^\t#!/ ){
      $_ =~ s/^\t//;
      $not .= "\n$_";
    } elsif ( /^\t/ ){
      $_ =~ s/^\t//;
      $rtn .= "\n$_";
    } elsif ( /^#/ ){
      # Comment
      $cmt .= "\n".$_;
    } else {
      die "unknown _:'$_'";
    }
  }
  if ( $cmd ne '' ){
    push @cmds,$cmd;
    push @rtns,$rtn;
    push @cmts,'';
    push @nots,$not;
  }
  if ( $cmt ne '' ){
    push @cmds,'##';
    push @rtns,'';
    push @cmts,$cmt;
    push @nots,'';
  }
  #
  $self->{'host'}  = $host;
  $self->{'user'}  = $user;
  $self->{'logf'}  = $logf;
  $self->{'sheet'} = $sheet;
  
  @{ $self->{'cmds'} } = @cmds;
  @{ $self->{'rtns'} } = @rtns;
  @{ $self->{'cmts'} } = @cmts;
  @{ $self->{'nots'} } = @nots;
}
1;
