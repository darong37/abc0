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
# $DB::single = 1 if $cnt > 20;
### termRepl
my $timout = 2;
my $regexP = '/.*[\$>:?#%] +$/';

### 補助入力
sub auxread {
  my ( $telnet ) = @_ ;
  my @result;

  my @buffer=();
  my $ans='';
  my $last='';
  do{
    $ans = 0 unless $ans =~ /^[0-9]+$/;

    my $n=0;
    while( $n < $ans+1 ){
      while(@buffer = $telnet->getlines(All => 0) ){
        if ( $last ne '' ){
          unshift @buffer,$last;
          $last='';
        }
        print @buffer if @buffer;
        $ans = 0;
        $n=0;
      }
      sleep $timout;
      $n++;
    }
    $last = $telnet->get(Timeout => 0) || '';
    
    if ( eval '$last =~ '.$regexP ){
      $ans=" ";
    } else {
    
      my $dat=$last;
      if ( $dat ne '' ){
        $dat =~ s/(.|\n)+\n//g;
      }
      printf "\n\n\033[%dA\n",2;
      $ans = inputT  "	Wait or Enter('$dat')";
                                    # 標準入力から１行分のデータを受け取る
      printf "\033[%dA",2;          # カーソルを2行だけ上に移動
      printf "\033[J\033[%dA\n",1;  # 位置の右以降をクリア、1行上移動し改行
    }
  } while($ans =~ /^[0-9]*$/ );
  
  push @result,@buffer;
# my $last = $telnet->get;
  push @result,$last;
  return @result;
}
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
my $host  = $stxt->{'host'};
my $user  = $stxt->{'user'};
my $logf  = $stxt->{'logf'};
my $sheet = $stxt->{'sheet'};

print "# Host   : $host\n";
print "# User   : $user\n";
print "# Log    : $logf\n";
print "# Sheet  : $sheet\n";

my @cmds = @{ $stxt->{'cmds'} };
my @rtns = @{ $stxt->{'rtns'} };
my @cmts = @{ $stxt->{'cmts'} };
my @nots = @{ $stxt->{'nots'} };

my $pass = `sh /c/Users/JKK0544/.abc/bin/spass $host $user`;

#open my $logh,">> $logf" or die "can not open $logf";
open my $logh,"| logging.pl $logf" or die "can not open $logf";
print $logh "# Host   : $host\n";
print $logh "# User   : $user\n";
print $logh "# Log    : $logf\n";
print $logh "# Sheet  : $sheet\n";

#my ( $telnet,$last ) = termRepl($host,$user,$pass,$logh);
### Telnet
my $telnet = new Net::Telnet(
  Timeout   => $timout,
  Prompt    => $regexP, # プロンプト(正規表現)
  Errmode   => "return",
  Input_log => $logh,
);
$telnet->max_buffer_length(10485760);

### ホストに接続してログインする
$telnet->open($host);
my @result0 = $telnet->login($user, $pass);

### 初期コマンドの実行
my $init = <<'EOS';
  export PS1='% '
  TERM=vt100
  stty rows 50 columns 144
EOS

# 実行
for ( split /\n/,$init ){
  s/^\s+//;
  print "\% $_\n";
  @result0 = $telnet->cmd($_);
  print @result0;
}
my $last = $telnet->last_prompt;

### シグナル制御
$SIG{'INT'} = $SIG{'TERM'} = $SIG{'HUP'} = $SIG{'QUIT'} = 'Inthandler';
sub Inthandler {
  print STDERR "\nyou hit break!,   do you want to\n";
  print STDERR "  0) No op\n";
  print STDERR "  1) Send BREAK \n";
  print STDERR "  2) forced exit\n";
  print STDERR "> ";

  my $ans = input('No.','0');  # 標準入力から１行分のデータを受け取る
#  if ( $ans == 0 ){
#    $telnet->cmd('');
#  } els
  if ( $ans == 1 ) {
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
  s/[\r\n]$//g;
  #
  if ( /^\!\!/ ){
    if ( $_ eq '!!review' ){
      exregex($rtns[$cnt-1],$target,1);
    } elsif( /^\!\!reset/ ) {
      $stxt->read;
      @cmds = @{ $stxt->{'cmds'} };
      @rtns = @{ $stxt->{'rtns'} };
      @cmts = @{ $stxt->{'cmts'} };
      @nots = @{ $stxt->{'nots'} };
      print "# Host   : $host\n";
      print "# User   : $user\n";
      print "# Log    : $logf\n";
      print "# Sheet  : $sheet\n";
      my $i=0;
      for ( @cmds ){
        printf "!!%2d  %s\n",$i++,$_;
      }
      do{
        $cnt = input('!!',"$cnt");       # 標準入力から１行分のデータを受け取る
      } until ( $cnt =~ /^[0-9]+$/ );
      $keyboad->addhistory($cmds[$cnt]);
      
    } elsif( /^\!\!add/ ) {
      my $add = inputS 'Commands';
      my @adds = split /\n/,$add;
      @adds = map { s/^[\$>] //;$_ } @adds;
      splice @cmds,$cnt,0,@adds;
      
      @adds = map { '' } @adds;
      splice @rtns,$cnt,0,@adds;
      splice @cmts,$cnt,0,@adds;
      splice @nots,$cnt,0,@adds;
      
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
      do{
        $cnt = input('!!',"$cnt");       # 標準入力から１行分のデータを受け取る
      } until ( $cnt =~ /^[0-9]+$/ );
      $keyboad->addhistory($cmds[$cnt]);
    }
  } else {
    my @result;
    if ( $_ eq '##' ){
      if ( $cmts[$cnt] ne '' ){
        print  CYAN;
        print  $cmts[$cnt];
        print  RESET;
        print  "\n";
        print  $logh  "##\n".$cmts[$cnt]."\n";
      }
      @result = $telnet->cmd('');
    } else {
      @result = $telnet->cmd($_);
    }
    #
    if ( @result ){
      $last = $telnet->last_prompt;
    } else {
      if ( $_ eq 'exit'){
        last if ask "\nAre you sure you want to quit telnet",'y';
      }
      @result = auxread($telnet);
      $last = shift @result;
    }
    $target = join '',@result;

    # 
#   s/^(#|-)+ *//;
    if ( $_ eq $cmds[$cnt] || $_ eq '#'.$cmds[$cnt] ){
      if ( $rtns[$cnt] ne '' ){
        exregex($rtns[$cnt],$target);
      } else {
        print $target;
      }
      #
      if ( $nots[$cnt] ne '' ){
        print  "\n";
        print  CYAN;
        print  REVERSE;
        print  $nots[$cnt];
        print  RESET."\n";
        
        print  $logh  $nots[$cnt]."\n";
        @result = $telnet->cmd('');
      }
      #
      if ( $cnt < @cmds ){
        $cnt++;
        $keyboad->addhistory($cmds[$cnt]);
      }
    } else {
      print $target;
    }
  }
}

### 接続の切断
close $logh;
$telnet->close;

=comment

=out
