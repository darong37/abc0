#!/bin/perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::ReadLine;

### openR
sub openR(&@){
  my ( $blocks,$rfn,$sen ) = @_;
  $sen |= '#EOF#';
  
  our $openRcount = 0;
  open my $rfh,"< $rfn" or return 0;
  
  my $cur=<$rfh> || return 0;
  while ( our $openRnext=<$rfh> || $sen) {
    $openRcount++;
    $_ = $cur;
    my $rtn = $blocks->();
    redo if $rtn eq 'redo';
    last if $rtn eq 'last';
    last if $openRnext eq $sen;
    $cur = $openRnext;
    next if $rtn eq 'next';
  }
  close $rfh;
}

### coloredGlass
sub coloredGlass {
  my ( $glass, $target ) = @_ ;   # 特殊変数からの引取り

  $glass  =~ s/\n+$/\n/;

  my $patterns = '';
  my $template = '';
  my $warn=1;      # color of next maching   0: Yellow,  else: Green

  ### Prev Syntax Sugar
  $glass =~ s/\{\n\s*/{/g;       # 行またぎ'{'
  $glass =~ s/\s*\n\s*\}/}/g;    # 行またぎ'}' 

  # 空行=Wildcard行
  $glass =~ s/\n(?:\s*\n)+([^\n{]+)/\n((?:.*\\n)+)(?=\Q$1\E)\n/g;

  $glass =~ s/\Q{*}\E/{(.*)}/g;  # {*} -> (.*)
  $glass =~ s/\Q{+}\E/{(.+)}/g;  # {+} -> (.+)
  
  $glass =~ s/\{([*+])Wait (.+)\}\n/{((?:.*\\n)$1)(?=.*\Q$2\E)}\n/g;    # {[*+]Wait *}
  
  ### Main Loop
  my $cnt=0;
  for ( split /\n/,$glass ){
    my $ptn = $_;
    my $tmp = $_;

    $cnt++;
    if ( /^\{.+\}$/ ){
      $tmp =  '%s';
      $ptn =~ s/[{}]//g;
    } elsif ( /\{\(.+?\)\}/ ) {
      $tmp =~ s/\{\(.+?\)\}/%s/g;
      $tmp .= "\n";

      # '{(' start REGEX.
      $ptn =~ s/\{\(/\\E\(/g;
      # ')}' end REGEX.
      $ptn =~ s/\)\}/\)\\Q/g;
      
      $ptn = '\Q'.$ptn.'\E\n?';
    } else {
      $tmp .= "\n";
      $ptn =  '\Q'.$ptn.'\E\n?';
    }

    if ( eval "\$target =~ m{$patterns$ptn}" ){
      $template .= $tmp;
      $patterns .= $ptn;
    } else {
      $target = printGlass( $target,$template,$patterns,$warn );

      printf "%s%s%s%s\n", RED,REVERSE,$_,RESET;
#     printf "%s%s%s\n", YELLOW,"# The avove pattern unmatched the following... ",RESET;
      $template = '%s';
      $patterns = '((?:.*\\n)+?)';
      $warn=0;
    }
  }
  $template =~ s/\n$//;
  $target = printGlass( $target,$template,$patterns,$warn );
  
  if ( $target =~ /^\s*\n*$/ ){
    printf "%s\n",RESET;
  } else {
    printf "%s\n%s",RESET,"$target";
  }
}

sub printGlass {
  my ( $target,$template,$patterns,$warn ) = @_;
  #
  my @eles = ( eval "\$target =~ m{$patterns((?:.*\\n?)+?.*)\$}" );
  if ( @eles ){
    $target = pop @eles;
  } else {
    @eles = ( '' );
  }

  if ( @eles ){
    @eles = map{ sprintf "%s%s%s", $warn++ > 0 ? GREEN : RED ,$_,BLUE } @eles;
    printf("%s$template%s", BLUE,@eles,RESET);
  } else {
    print BLUE;
    print $template;
    print RESET;
  }
  return $target;
}


### termRepl
sub termRepl {
  my ( $hkey,$logf ) = @_ ;
  
  ### Telnet
  open my $logh,"> $logf" or die "can not open $logf";
  my $telnet = new Net::Telnet(
    Timeout   => 3,
    Prompt    => '/\S*[\$#>:]\s*$/', # プロンプト(正規表現)
    Errmode   => "return",
    Input_log => $logh,
  );

  ### 接続情報(telnet.hostsに記述)取得
  my ( $host, $user, $desc, $sharp, $pass );
  openR{
    if ( /^$hkey/ ){
      ( $host, $user, $desc, $sharp, $pass ) = split /\s*\t/;
    }
  } "./telnet.hosts";

  ### ホストに接続してログインする
  $telnet->open($host);
  my @result = $telnet->login($user, $pass);
  if ( @result ){
    $telnet->input_log;
    close $logh;
    
    open $logh,"< $logf" or die "can not open $logf";
    while(<$logh>){
      print $_;
    }
    close $logh;
    
    open my $logh,">> $logf" or die "can not open $logf";
    $telnet->input_log($logh);
  }

  ### 初期コマンドの実行
  my $init = <<'EOS';
    TERM=vt100
    stty rows 50 columns 144
    cd /u00/unyo
    uname -n
    whoami
    pwd
    date
    export PS1='$ '
EOS

  # 実行
  for ( split /\n/,$init ){
    s/^\s+//;
    print "\$ $_\n";
    @result = $telnet->cmd($_);
    print @result;
  }
  my $last = $telnet->last_prompt;
  
  return ( $telnet,$last );
}

### 補助入力
sub auxread {
  my ( $telnet ) = @_ ;
  my @result;
  
  while(my @buff = $telnet->getlines(All => 0) ){
    push @result,@buff;
  }
  my $last = $telnet->get;
  push @result,$last if $last;
  return @result;
}

1;
