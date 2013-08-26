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
use stxt;

use IO::Handle;
STDOUT->autoflush(1);
STDERR->autoflush(1);

###
$Term::ANSIColor::AUTORESET = 0;
print RESET;

chdir 'oper';
my $wd = Cwd::getcwd();
print "Current: $wd\n";


### Arguments
my ( $stxtFile ) = @ARGV;
print "S-text : $stxtFile\n";

### STXT
my $stxt = Stxt->new($stxtFile);
$stxt->read;


### TermREPL
my $host = $stxt->{'host'};
my $user = $stxt->{'user'};
my $logf = $stxt->{'logf'};

print "Host   : $host\n";
print "User   : $user\n";
print "Log    : $logf\n";

my @cmds = @{ $stxt->{'cmds'} };
my @rtns = @{ $stxt->{'rtns'} };

my $pass = `sh /c/Users/JKK0544/.abc/bin/spass $host $user`;
my ( $telnet,$last ) = termRepl($host,$user,$pass,"$logf");

### シグナル制御
$SIG{'INT'}  = 'Inthandler';
sub Inthandler {
  print STDERR "you hit break!,   do you want to\n";
  print STDERR "  0) No op\n";
  print STDERR "  1) Send BREAK \n";
  print STDERR "  2) forced exit\n";

  $/ = "\n";
  my $ans = <STDIN>;  # 標準入力から１行分のデータを受け取る
  chomp $ans;         # $in の末尾にある改行文字を削除
  if ( $ans == 1 ){
    my $ok = $telnet->break;
    print STDERR "send break($ok)!\n";
  } elsif ( $ans == 2 ) {
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
    } elsif( /^\!\!reset/ ) {
      $stxt->read;
      @cmds = @{ $stxt->{'cmds'} };
      @rtns = @{ $stxt->{'rtns'} };
#     undef $keyboad;
#     $keyboad = new Term::ReadLine 'my_term';
      $cnt=0;
      $keyboad->addhistory($cmds[$cnt]);
    } elsif( /^\!\![0-9]+/ ) {
      s/^\!\!//;
      s/[\r\n]//g;
      $cnt = $_;
      $keyboad->addhistory($cmds[$cnt]);
    } elsif( /^\!\!/ ) {
      my $i=0;
      for ( @cmds ){
        printf "!!%2d  %s\n",$i++,$_;
      }
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
