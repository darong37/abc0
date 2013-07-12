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

coloredGlass($gls,$tgt);

exit;

#
# subroutine
#
sub coloredGlass {
  my ( $glass, $target ) = @_ ;   # “ÁŽê•Ï”‚©‚ç‚ÌˆøŽæ‚è

  ### Seqencial Matching
  $glass  =~ s/\n+$/\n/;
  $target =~ s/\n+$/\n/;

  $glass  .= "### sentinel ###";

  my $patterns = '';
  my $template = '';
  my $warn=1;      # color of next maching   0: Yellow,  else: Green

  ### Prev Syntax Sugar
  $glass =~ s/\{\n\s*/{/g;       # s‚Ü‚½‚¬'{'
  $glass =~ s/\s*\n\s*\}/}/g;    # s‚Ü‚½‚¬'}' 

  $glass =~ s/\Q{*}\E/{(.*)}/g;  # {*} -> (.*)
  $glass =~ s/\Q{+}\E/{(.+)}/g;  # {+} -> (.+)
  
  $glass =~ s/\{([*+])Wait (.+)\}\n/{((?:.*\\n)$1)(?=.*\Q$2\E)}\n/g;    # {?Wait *}
  
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
      
      $ptn = '\Q'.$ptn.'\E\n';
    } else {
      $tmp .= "\n";
      $ptn =  '\Q'.$ptn.'\E\n';
    }

    if ( eval "\$target =~ m{$patterns$ptn}" ){
      $template .= $tmp;
      $patterns .= $ptn;
    } else {
      my @eles = ( eval "\$target =~ m{$patterns((?:.*\\n?)+?.*)\$}" );
      if ( @eles ){
        $target = pop @eles;
      } else {
#       $target = '';
#       print "  (empty)\n";
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

      if ( /### sentinel ###/ ){
        if ( $target =~ /^\s*\n*$/ ){
          print RESET;
        } else {
          print RESET  "# remainder\n";
          print "$target\n";
        }
      } else {
        printf "%s%s%s%s\n", RED,REVERSE,$_,RESET;
#       printf "%s%s%s\n", YELLOW,"# The avove pattern unmatched the following... ",RESET;
        $template = '%s';
        $patterns = '((?:.*\\n)+?)';
        $warn=0;
      }
    }
  };
}



