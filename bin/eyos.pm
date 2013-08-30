#!/bin/perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::ReadLine;
use POSIX 'strftime';


###
sub now {
  return strftime "%Y/%m/%d %H:%M:%S", localtime;
}
sub input {
  my $prompt = shift;
  open( my $in ,">&STDIN" ) || die "can not open dup STDIN";
  
  my $stock = $/;
  print "$prompt > ";
  $/="\n";
  chomp( my $rtn = <$in> );
  $rtn =~ s/\r$//;

  close $in;
  $/=$stock;
  return $rtn;
}
sub inputS {
  my $prompt = shift;
  open( my $in ,">&STDIN" ) || die "can not open dup STDIN";
  
  my $stock = $/;
  print "$prompt <<CTRL-D\n";
  $/="";
  chomp( my $rtn = <$in> );
  $rtn =~ s/\r$//;

  close $in;
  $/=$stock;
  return $rtn;
}
sub ask {
  my ( $prompt,$default ) = @_;
  open( my $in ,">&STDIN" ) || die "can not open dup STDIN";
  
  my $stock = $/;
  print "$prompt ?[(y)es/(n)o] > ";
  $/="\n";
  chomp( my $rtn = <$in> );
  $rtn =~ s/\r$//;
  $rtn = $default if $rtn eq '';

  close $in;
  $/=$stock;
  
  if ( $rtn =~ /^[yY]/ ){
    return 'y';
  } else {
#   return 'n';
    return '';
  }
}
sub stock {
  my ( $n,@src ) = @_;
  my @rtn;
  if ( $n < $#src ){
    for( my $idx=$n;$idx<$n+3;$idx++ ){
      if ( $idx < 0 ){
        push @rtn,'';
      } elsif ( $idx > $#src){
        push @rtn,'';
      } else {
        push @rtn,$src[$idx];
      }
    }
    return @rtn;
  } else {
    return ();
  }
}
{
  package Stock;
  
  sub new {
    my $pkg = shift;
    bless {
      count => -1,
      stock => [ '','' ],
      eof   => 0,
    },$pkg;
  }
  
  sub file {
    my $self = shift;
    my $filehandle = shift;
    
    if ( $self->{eof} == 1 ) { return () };
    shift @{$self->{stock}};
    for (my $idx=$self->{count}; $#{$self->{stock}} < 2; $idx++){
      my $lin;
      if ( $lin = <$filehandle> ){
        chomp $lin;
        push @{$self->{stock}},$lin;
        $self->{count}++;
      } else {
        push @{$self->{stock}},'';
        $self->{eof} = 1;
      }
    }
    if ( $self->{eof} == 1 ) { $self->{count}++; };
    return @{$self->{stock}};
  }
  
  sub array {
    my $self = shift;
    my @eles = @_;
    
    if ( $self->{eof} == 1 ) { return () };
    shift @{$self->{stock}};
    for (my $idx=$self->{count}+1; $#{$self->{stock}} < 2; $idx++){
      my $ele;
      if ( $idx <= $#eles ){
        $ele = $eles[$idx];
        push @{$self->{stock}},$ele;
        $self->{count}++;
      } else {
        push @{$self->{stock}},'';
        $self->{eof} = 1;
      }
    }
    if ( $self->{eof} == 1 ) { $self->{count}++; };
    return @{$self->{stock}};
  }
  1;
}
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

# $srcptn .= "\n";

  if ( $dbg ){
    print "\n-- interim-1 --\n";
    print "'$srcptn'";
    print "\n--\n";
  }
  #
  # 分解
  #
  my @orgs;
  my $org='';
  my $flg=0;
  for ( split //,$srcptn ){
# my $n=-1;
# while ( my ($prev,$cur,$next) = stock( $n++,split //,$srcptn ) ){
    #
    if(/\n/) {
      push @orgs,$org if $org ne '';
      my $last = $orgs[-1] || '';
      if ( $last eq '\n' ){
        push @orgs,'{_}';
      } elsif ( $last ne '{:}' && $last ne '{_}' ){
        push @orgs,'\n';
      }
      $org='';
    } elsif(/\{/){
      push @orgs,$org if $org ne '';
      $org = $_;
      $flg = 1;
    } elsif(/\}/){
      $org .= $_;
      push @orgs,$org if $org ne '';
      $org = '';
      $flg = 0;
    } elsif($flg==1){
      $org .= $_;
    } elsif(/[\$\@]/){
      push @orgs,$org if $org ne '';
      push @orgs,$_;
      $org = '';
    } elsif(/\s/){
      if ( $org =~ /^\s*$/ ){
        $org .= $_;
      } else {
        push @orgs,$org if $org ne '';
        $org = $_;
      }
    } else {
      if ( $org =~ /^\s+$/ ){
        push @orgs,$org if $org ne '';
        $org = $_;
      } else {
        $org .= $_;
      }
    }
  }
  push @orgs,$org if $org ne '';
  my $cnt=0;
  if ( $dbg ){
    print "\n-- interim-2 --\n";
    map { printf "%03d:'%s'\n",$cnt++,$_ } @orgs;
    print "\ntotal $#orgs +1 elements\n";
    print "\n--\n";
  }
  #
  # 再結合
  #
  my @patterns;
  my @formats;
  for ( @orgs ){
    if ( $_ eq '\n' ){
      push @patterns,' \n';
      push @formats ,"\n";
    } elsif ( $_ eq '{:}'){
      push @patterns,'((?:.|\n)*)';
      push @formats,'%s';
    } elsif ( $_ eq '{*}'){
      push @patterns,'(.*)';
      push @formats,'%s';
    } elsif ( $_ eq '{_}'){
      push @patterns,'([ \t\n]*)'."\n  ";
      push @formats,'%s';
    } elsif ( $_ eq '{num}'){
      push @patterns,'([0-9]+)';
      push @formats,'%s';
    } elsif ( $_ eq '{dat}'){
      push @patterns,'([0-3 ][0-9]-(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-20[01][0-9])';
      push @formats,'%s';
    } elsif ( $_ eq '{tim}'){
      push @patterns,'([0-2 ][0-9]:[0-5][0-9]:[0-5][0-9])';
      push @formats,'%s';
    } elsif ( /^[\$\@]$/ ){
      push @patterns,'\\'.$_;
      push @formats,$_;
    } elsif ( /^\{.+\}$/ ){
      s/[{}]//g;
      push @patterns,$_;
      push @formats,'%s';
    } elsif ( /^\s+$/ ){
      if ( $#patterns < 0 ){
        push @patterns,'\s+';
        push @formats,$_;
      } else {
        $patterns[-1] .= '\s+';
        $formats[-1]  .= $_;
      }
    } else {
      push @patterns,'\Q'.$_.'\E';
      push @formats,$_;
    }
  }
  if ( $dbg ){
    print "\n-- interim-3 --\n";
    $cnt=0;
    map { printf "%03d:'%s'\n",$cnt++,$_ } @patterns;
    print "\npatterns total $#patterns +1 elements\n";
    print "\n--\n";
    printf "'%s'",join('',@formats);
    print "\nformats total $#formats +1 elements\n";
    print "\n--\n";
  }
  
  #
  # 評価
  #
  my @plin;
  my @fmts;
  $cnt=0;
  for ( @patterns ){
#   $DB::single = 1 if $cnt > 20;
    push @plin,$_;
    push @fmts,shift(@formats);
    if ( $_ eq ' \n' || $cnt == $#patterns ){
      my $ptn  = join '',@plin;
      my $fmt  = join '',@fmts;
      my @eles = ();
      if ( eval '$target =~ m{'.$ptn.'}x' ){
         $target = colorprint($target,$fmt,$ptn);
      } else {
        for $ptn (@plin){
          if ( eval '$target =~ m{'.$ptn.'}x' ){
            $fmt = shift @fmts;
            $target = colorprint($target,$fmt,$ptn);
          } else {
            shift @fmts;
          }
        }
      }
      @plin = ();
      @fmts = ();
    }
    $cnt++;
  }
  $target =~ s/\n$//;
  if ( $target ne '' ){
    print YELLOW;
    print $target;
  }
  print RESET."\n";
  $DB::single = 1; # 
  return;
}

sub colorprint {
  my ( $target,$fmt,$ptn ) = @_;

  my @eles;
  if        ( eval '$target =~ m{^'.$ptn.'}x' ){
    @eles = ( eval '$target =~ m{^'.$ptn.'((?:.|\n)*)'.'$}x' );
    $target = pop @eles;
    @eles = map { sprintf "%s%s%s",GREEN,$_,BLUE } @eles;
    
    print  BLUE;
    printf $fmt,@eles;
    print  RESET;
  } else {
    @eles = ( eval '$target =~ m{^'.'((?:.|\n)*?)'.$ptn.'((?:.|\n)*)'.'$}x' );
    
    my $prev = shift @eles;
    $target  = pop @eles;
    unless ( @eles ){ @eles = ( '' ) }
    
    print  RED;
    printf '%s',$prev;
    print  RESET;

    @eles = map { sprintf "%s%s%s",GREEN,$_,BLUE } @eles;
    print  BLUE;
    printf $fmt,@eles;
    print  RESET;
  }
  return $target;
}

### termRepl
my $timout = 2;
sub termRepl {
  my ( $host, $user, $pass, $logh ) = @_ ;
  
  ### Telnet
  my $telnet = new Net::Telnet(
    Timeout   => $timout,
    Prompt    => '/.*[\$>:?#%] *$/', # プロンプト(正規表現)
    Errmode   => "return",
    Input_log => $logh,
  );
  $telnet->max_buffer_length(10485760);

  ### ホストに接続してログインする
  $telnet->open($host);
  my @result = $telnet->login($user, $pass);

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

  my @buffer=();
  my $ans='';
  do{
    $ans = 0 unless $ans =~ /^[0-9]+$/;

    my $n=0;
    while( $n < $ans+1 ){
      while(my @buffer = $telnet->getlines(All => 0) ){
        print @buffer if @buffer;
        $n=0;
      }
      sleep $timout;
      $n++;
    }
    printf "\n\n\033[%dA\n",2;
    $ans = input '-- Time out!, <enter|integer>:repeat else:exit-aux';
                                  # 標準入力から１行分のデータを受け取る
    printf "\033[%dA",2;          # カーソルを2行だけ上に移動
    printf "\033[J\033[%dA\n",1;  # 位置の右以降をクリア、1行上移動し改行
  } while($ans =~ /^[0-9]*$/ );
  
  push @result,@buffer;
  my $last = $telnet->get;
  push @result,$last if $last;
  return @result;
}

1;
