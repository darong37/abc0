#!/bin/perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);

$Term::ANSIColor::AUTORESET = 0;
print RESET;

### Arguments
my ( $glsFil, $tgtFil ) = @ARGV;

### Glass File
$/ = undef;
open GLS,"<$glsFil" or die "not found '$glsFil'";
my $gls = <GLS>;
close GLS;

### Target File
$/ = undef;
open  TGT,"<$tgtFil" or die "not found '$tgtFil'";
my $tgt = <TGT>;
close TGT;




### Seqencial Matching
$gls .= "### sentinel ###";
$tgt .= "\n";

my $patterns = '';
my $template = '';
my $warn=1;      # color of next maching   0: Yellow,  else: Green

my $cnt=0;
#while(<PTN>){
for ( split /\n/,$gls ){
  chomp;
  my $tmp = $_;
  my $ptn = $_;
  
  #
  $cnt++;
  if ( /^\{.+\}$/ ){
    $tmp =  '%s';
    $ptn =~ s/[{}]//g;
  } elsif ( /\{\(.+\)\}/ ) {
    $tmp =~ s/\{\(.+\)\}/%s/g;
    $tmp .= "\n";

    # '{(' start REGEX.
    $ptn =~ s/\{\(/\\E\(/g;
    # ')}' end REGEX.
    $ptn =~ s/\)\}/\)\\Q/g;
    
    $ptn = '\Q'.$ptn.'\E\n';
  } else {
    $tmp .= "\n";
    $ptn =  '\Q'.$ptn.'\E\n';
  }

  if ( eval "\$tgt =~ m{$patterns$ptn}" ){
    $template .= $tmp;
    $patterns .= $ptn;
  } else {
    my @eles = ( eval "\$tgt =~ m{$patterns((?:.*\\n)+)\$}" );
    $tgt = pop @eles;

    @eles = map{ sprintf "%s%s%s", $warn++ > 0 ? GREEN : YELLOW,$_,BLUE } @eles;
    printf("%s$template%s", BLUE,@eles,RESET);

    if ( /### sentinel ###/ ){
      if ( $tgt =~ /\n/ ){
        print RESET  "# period\n";
      } else {
        print RESET  "# remainder\n";
        print "'$tgt'\n";
      }
    } else {
      print RED    "$_\n";
      print RESET  "# The avove unmatched the following... \n";

      $template = '%s';
      $patterns = '((?:.*\\n)+)';
      $warn=0;
    }
  }
};

exit;
