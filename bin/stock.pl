#!/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin";
use eyos;

my @src = ( 'a','b','c','d','e','f' );
my @stock = ( '' );
for ( @src,'','' ){
  if ( $#stock == 2 ){
    #
    print join(',',@stock);
    print "\n";
    #
    shift @stock;
  }
  push @stock,$_;
}

print "-----\n";

@src = ( 'a','b','c','d','e','f' );

my $n=-1;
while( my( $prev,$cur,$next ) = stock($n++,@src)  ){
  printf "%02d: %s,%s,%s\n",$n,$prev,$cur,$next;
}
print "Total $n rows\n";

print "-----\n";

open my $fh,"< ./a.txt" or die;

my $stock = Stock->new;

while( my( $prev,$cur,$next ) = $stock->file($fh)  ){
  printf "%02d: %s,%s,%s\n",$stock->{count},$prev,$cur,$next;
}
close $fh;
printf "Total %s rows\n",$stock->{count};

print "-----\n";

@src = ( 'a','b','c','d','e','f' );
$stock = Stock->new;
while( my( $prev,$cur,$next ) = $stock->array(@src)  ){
  printf "%02d: %s,%s,%s\n",$stock->{count},$prev,$cur,$next;
}
print "Total $n rows\n";

