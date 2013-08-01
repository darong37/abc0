#!/bin/perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::ReadLine;


### exregex
sub exregex{
  my ( $srcptn,$target,$dbg ) = @_;
  if ( $dbg ){
    print "\n-- target --\n";
    print "'$target'";
    print "\n--\n";
  }
  #
  # 行またぎ{}
  #
  $srcptn =~ s/^[ \t\n]+//;        # 先頭スペース
  $srcptn =~ s/\n+$//;             # 終端改行
  
  $srcptn =~ s/(?=\n)[ \t]\n/\n/g; # 空行
  $srcptn =~ s/\n\n+/\n\n/g;       # 複数空行
  $srcptn =~ s/\n[ \t]*\{/\n{/g;   # ^' {'
  $srcptn =~ s/\{[ \t\n]+/{/g;     #  '{ '
  $srcptn =~ s/\}[ \t]*\n/}\n/g;   #  '} '$
  $srcptn =~ s/[ \t\n]+\}/}/g;     #  ' }'

# $srcptn =~ s/\{:\}\n/{:}/g;      #  ' }'

  if ( $dbg ){
    print "\n-- interim-1 --\n";
    print "'$srcptn'";
    print "\n--\n";
  }

  my @eles;
  my $ele = '';
  my $flg=0;
  for ( split //,$srcptn ){
    if(/\n/) {
      if ( $ele eq '' ){
        my $last = $eles[-1] || '';
        if ( $last =~ /^\{.+\}$/ ){
          push @eles,'\n';
        } else {
          push @eles,'{_}';
          push @eles,'\n';
        }
      } else {
        push @eles,$ele;
        push @eles,'\n';
      }
      $ele='';
    } elsif(/\{/){
      push @eles,$ele if $ele ne '';
      $ele = $_;
      $flg = 1;
    } elsif(/\}/){
      $ele .= $_;
      push @eles,$ele if $ele ne '';
      $ele = '';
      $flg = 0;
    } elsif($flg==1){
      $ele .= $_;
    } elsif(/[\$\@]/){
      push @eles,$ele if $ele ne '';
      push @eles,$_;
      $ele = '';
    } elsif(/\s/){
      if ( $ele =~ /^\s*$/ ){
        $ele .= $_;
      } else {
        push @eles,$ele if $ele ne '';
        $ele = $_;
      }
    } else {
      if ( $ele =~ /^\s+$/ ){
        push @eles,$ele if $ele ne '';
        $ele = $_;
      } else {
        $ele .= $_;
      }
    }
  }
  push @eles,$ele if $ele ne '';
  #
  
  my $cnt=0;
  if ( $dbg ){
    print "\n-- interim-2 --\n";
    map { printf "%03d:'%s'\n",$cnt++,$_ } @eles;
    print "\ntotal $#eles +1 elements\n";
    print "\n--\n";
  }
  
  $cnt=0;
  my $nmatched=0;
  my $nunmatch=0;
  # 未評価（前）
  my @patterns=( '((?:.*\n)*)' );
  my @formats =( YELLOW.'%s'.RESET );
  my @orgs;
  for ( @eles ){
    my ( $p,$f,$wp,$wf );
    if      ( $_ eq '{*}'){
      $p  = '(.*)';
      $f  = '%s';
      $wp = '(.*)';
      $wf = '%s';
    } elsif ( $_ eq '{:}'){
      $p  = '((?:.|\n)*)';
      $f  = '%s';
      $wp = '((?:.|\n)*)';
      $wf = '%s';
    } elsif ( $_ eq '{_}'){
      $p  = '([ \t\n]*)';
      $f  = '%s';
      $wp = '([ \t\n]*)';
      $wf = '%s';
    } elsif ( $_ eq '{num}'){
      $p  = '([0-9]*)';
      $f  = '%s';
      $wp = '(.*)';
      $wf = '%s';
    } elsif ( $_ eq '{tim}'){
      $p  = '([0-2 ][0-9]:[0-5][0-9]:[0-5][0-9])';
      $f  = '%s';
      $wp = '(.*)';
      $wf = '%s';
    } elsif ( $_ eq '\n' ){
      $p  = '\n{1}';
      $f  = "\n";
      $wp = '(\n?)';
      $wf = '%s';
    } elsif ( /^[\$\@]$/ ){
      $p  = '\\'.$_;
      $f  = $_;
      $wp = '(.*)';
      $wf = '%s';
    } elsif ( /^\{.+\}$/ ){
      s/[{}]//g;
      $p  = $_;
      $f  = '%s';
      $wp = '(.*\n?)';
      $wf = '%s';
    } elsif ( /^\s+$/ ){
      $p  = '\Q'.$_.'\E';
      $f  = $_;
      $wp = '(\s*)';
      $wf = '%s';
    } else {
      $p  = '\Q'.$_.'\E';
      $f  = $_;
      $wp = '(.*)';
      $wf = '%s';
    }
    my $o = $_;
    #
    my $ptn = join('',@patterns);
    if ( eval '$target =~ m{^'.$ptn.$p.'}x' ){
      $nmatched++;
      if ( $p =~ /^\\Q/ && $patterns[-1] =~ /\\E$/ ){
        my $pp = pop @patterns;
        my $po = pop @orgs;
        my $pf = pop @formats;
        $p = "$pp$p";
        $p =~ s/\\E\\Q//g;
        $f = "$po$f";
        $o = "$po$o";
        $nmatched--;
      }
      push @patterns,$p;
      if ( $f eq '%s' ){
        push @formats ,GREEN.$f.RESET;
      } else {
        push @formats ,BLUE.$f.RESET;
      }
      if ( $dbg ){
        printf "matched(%03d): '$p'\n",$nmatched;
      }
    } else {
      $nunmatch++;
      if ( $nunmatch > $nmatched+10 ){
        last 
      }
      
      if ( $patterns[-1] eq '(.*)' || $patterns[-1] eq '(,*)' ){
        

      }
      unless ( eval '$target =~ m{^'.$ptn.$wp.'}x' ){
        print "\n-- unkown --\n";
        print "'$ptn'";
        print "\n--\n";
        my $format = join '',@formats;
        print "\n-- format --\n";
        print "'$format'";
        print "\n--\n";
        die "sanna baka na";
      }
      push @patterns,$wp;
      push @formats ,RED.$wf.RESET;
      if ( $dbg ){
        printf "unmatch(%03d): '$p' -> '$wp'\n",$nunmatch;
      }
    }
    push @orgs,$o;
  }
  # 未評価（後）
  push @patterns,'((?:.|\n)*)';
  push @formats ,YELLOW.'%s'.RESET;

  #
  my $ptn = join('',@patterns);
  unless ( eval '$target =~ m{^'.$ptn.'$}x' ){
    print "\n-- unknown --\n";
    print "'$ptn'";
    print "\n--\n";
    my $format = join '',@formats;
    print "\n-- format --\n";
    print "'$format'";
    print "\n--\n";
    die "arienai";
  }
  @eles = ( eval '$target =~ m{^'.$ptn.'$}x' );
  my $format = join '',@formats;
# my $fc = ( $format =~ s/%s/%s/g );
# for( my $c=0; $c < $fc; $c++){
#   $eles[$c] = '' unless defined $eles[$c];
# }
  my $result = sprintf($format, @eles);

if ( $dbg ){
  print "\n-- format --\n";
  print "'$format'";
  print "\n--\n";
  $ptn =~ s/\\n\{1\}/\n/g;
  $ptn =~ s/\)\\Q/)\n\\Q/;
  $ptn =~ s/\\(Q|E)/'/g; # '
  print "\n-- pattern --\n";
  print "$ptn";
  print "\n--\n";
  print "\n-- elements --\n";
  $cnt=0;
  map { printf "%03d:'%s'\n",$cnt++,$_ } @eles;
  print "\ntotal $#eles elements\n";
  print "\n--\n";
  print "\n-- result --\n";
  print "'$result'";
  print "\n--\n";
}
  
  return $result;
}

### termRepl
sub termRepl {
  my ( $host, $user, $pass, $logf ) = @_ ;
  
  ### Telnet
  open my $logh,"> $logf" or die "can not open $logf";
  my $telnet = new Net::Telnet(
    Timeout   => 3,
    Prompt    => '/\S*[\$#>:]\s*$/', # プロンプト(正規表現)
    Errmode   => "return",
    Input_log => $logh,
  );

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
