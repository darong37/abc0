#!/bin/perl
use strict;
use warnings;
use Cwd;

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
my ( $telnet,$last ) = termRepl($host,$user,$pass,"$wd/$log");

### シグナル制御
$SIG{'INT'}  = 'Inthandler';
sub Inthandler {
  my $ok = $telnet->break;
  print STDERR "you hit break($ok)!\n";
}

my $keyboad = new Term::ReadLine 'my_term';
my $cnt=0;
my $cmd = $cmds[$cnt];
my $rtn = $rtns[$cnt];
$keyboad->addhistory($cmd);

my $target;
my $prvrtn;
my $prvtar;
while ( defined($_ = $keyboad->readline($last)) ) {
  if ( $_ eq '!prev' ){
    $target = exregex($prvrtn,$prvtar,1);
    print $target;
    print RESET;
    next;
  }
  my @result = $telnet->cmd($_);
  if ( @result ){
    $last = $telnet->last_prompt;
  } else {
    @result = auxread($telnet);
    $last = '> ';
  }
  
  # valuation
  $target = join '',@result;

  # 
  chomp;
  if ( $_ eq $cmd ){
    if ( $rtn ne '' ){
      $prvrtn = $rtn;
      $prvtar = $target;
      $target = exregex($rtn,$target);
    }
    $cnt++;
    $cmd = $cmds[$cnt];
    $rtn = $rtns[$cnt];
    $keyboad->addhistory($cmd);
  } elsif( $_ eq '' ) {
    $cnt++;
    $cmd = $cmds[$cnt];
    $rtn = $rtns[$cnt];
    $keyboad->addhistory($cmd);
  }
  print $target;
  print RESET;
}

### 接続の切断
$telnet->close;

=comment

=out
