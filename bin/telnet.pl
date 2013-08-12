#!/bin/perl
use strict;
use warnings;
use Cwd;
use File::Basename;

use Net::Telnet;
use Term::ANSIColor qw(:constants);
use Term::ReadLine;

use FindBin;
use lib "$FindBin::Bin";
use eyos;


###
$Term::ANSIColor::AUTORESET = 0;
print RESET;

chdir 'oper';
my $wd = Cwd::getcwd();
print "Current: $wd\n";

### Arguments
my ( $stxtFile ) = @ARGV;

### STXT
open my $stxtH,"< $stxtFile" or die "can not open $stxtFile";
$/ = undef;
my $stxt = <$stxtH>;
close $stxtH;

$stxt =~ s/^[ \t\n]+//;        # 先頭スペース
$stxt =~ s/[ \t\n]+$//;        # 終端スペース
$stxt = "\n$stxt\n";           # 先頭終端改行付加

$stxt =~ s/(?<=\n)###+\n//g;
$stxt =~ s/(?<=\n)\s*\n//g;
$stxt =~ s/(?<=\n)[#>\$]\s*\n//g;

$stxt =~ s/^\n//;              # 先頭改行削除
$stxt =~ s/\n$//;              # 終端改行削除

$stxt =~ s/(?<=\n)([#>\$])/\n$1/g;

my $host;
my $user;
my $log;

my @cmds;
my @rtns;

for my $blk (split /\n\n/,$stxt){
  if ($blk =~ /^#\@/){
    ( $host ) = $blk =~ /^#\@host: (.+)\s*$/ if $blk =~ /^#\@host: /;
    ( $user ) = $blk =~ /^#\@user: (.+)\s*$/ if $blk =~ /^#\@user: /;
    ( $log  ) = $blk =~ /^#\@log: (.+)\s*$/  if $blk =~ /^#\@log: /;
    next;
  }
  # ?
  if ($blk =~ /^#/){
    next;
  }

  my $cmd = '';
  my $rtn = '';
  for my $lin (split /\n/,$blk){
    if ( $lin =~ /^#/ ){
      $cmd .= $lin;
    } elsif ( $lin =~ /^[>\$] / ){
      $lin =~ s/^[>\$] //;
      $cmd .= $lin;
    } elsif ( $lin =~ /^_ / ){
      $lin =~ s/^_ //;
#     $cmd .= "\n";
      $cmd .= '\n';
      $cmd .= $lin;
    } elsif ( $lin =~ /^\t/ ){
      $lin =~ s/^\t//;
      $rtn .= "$lin\n";
    } else {
      die "unknown lin:'$lin'";
    }
  }
  push @cmds,$cmd;
  push @rtns,$rtn;
}

#print "\n\n-- commands --\n";
#for ( my $cnt=0; $cnt < scalar(@cmds) ; $cnt++ ){
#  printf "%02d '$cmds[$cnt]' : '$rtns[$cnt]'\n",$cnt;
#}
#print "\n--";

####


### TermREPL
my $pass = `sh /c/Users/JKK0544/.abc/bin/spass $host $user`;
my ( $telnet,$last ) = termRepl($host,$user,$pass,"$log");

### シグナル制御
$SIG{'INT'}  = 'Inthandler';
sub Inthandler {
  print STDERR "you hit break!,   do you want to\n";
  print STDERR "  1) Send BREAK \n";
  print STDERR "  2) forced exit\n";

  $/ = "\n";
  my $ans = <STDIN>;  # 標準入力から１行分のデータを受け取る
  chomp $ans;         # $in の末尾にある改行文字を削除
  if ( $ans == 1 ){
    my $ok = $telnet->break;
    print STDERR "send break($ok)!\n";
  } else {
    die "Forced Exit";
  }
}

my $keyboad = new Term::ReadLine 'my_term';

my $cnt=0;
$keyboad->addhistory($cmds[$cnt]);

my $target;
while ( defined($_ = $keyboad->readline("$cnt $last")) ) {
  if ( /^\!\!/ ){
    if ( $_ eq '!!prev' ){
      exregex($rtns[$cnt-1],$target,1);
    } elsif( /^\!\![0-9]+/ ) {
      s/^\!\!//;
      $cnt = $_;
      $keyboad->addhistory($cmds[$cnt]);
    }
  } else {
    my @result = $telnet->cmd($_);
    if ( @result ){
      $last = $telnet->last_prompt;
    } else {
      last if $_ eq 'exit';
      @result = auxread($telnet);
      $last = '> ';
    }
    $target = join '',@result;

    # 
    chomp;
    if ( $_ eq $cmds[$cnt] ){
      if ( $rtns[$cnt] ne '' ){
        exregex($rtns[$cnt],$target);
      } else {
        print $target;
      }
      if ( $cnt <= $#cmds ){
        $cnt++;
        $keyboad->addhistory($cmds[$cnt]);
      }
    } else {
      print $target;
    }
  }
}

### 接続の切断
$telnet->close;

=comment

=out
