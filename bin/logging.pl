#!/bin/perl
use POSIX 'strftime';
use File::Basename;

my ( $outfln ) = @ARGV;
undef @ARGV;

my $dn = dirname($outfln);
my $bn = basename($outfln);

#
open my $OUT,">> $outfln"     or die "can not open $outfln";
open my $CMD,">> $dn/cmd.log" or die "can not open $dn/cmd.log";
sub output {
  my $lin = join '',@_;

  my $tim = strftime("%m/%d %H:%M:%S", localtime);
  if ( $lin eq '' ){
    printf $OUT "[%s]\n",$tim;
  } else {
    if ($lin =~ /^\S*[\$>] +[^#]/ && $lin !~ /export *PS1/ ){
      printf $CMD "[%s] %-60s  # %s\n",$tim,$lin,$bn;
    }
    printf $OUT "[%s] %s\n",$tim,$lin;
  }
}

### ÉVÉOÉiÉãêßå‰
$SIG{'INT'} = $SIG{'TERM'} = $SIG{'HUP'} = $SIG{'QUIT'} = 'Inthandler';
sub Inthandler {
  my $timend = time;
  my $timoff = $timend - $timbgn;

  output ;
  output "# received break";
  output "# execution ${timoff} sec.";
  print $OUT "\n\n\n";
  print $CMD "\n";

  close $OUT;
  close $CMD;
  
  exit;
}

#
my $timbgn = time;
while(<>){
  s/^\r//;
  s/\r?\n$//;
  #
  output $_;
}

my $timend = time;
my $timoff = $timend - $timbgn;

output ;
output "# execution ${timoff} sec.";
print $OUT "\n\n\n";
print $CMD "\n";

close $OUT;
close $CMD;

exit;
