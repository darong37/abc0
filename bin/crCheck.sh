#!/bin/sh -u
(( $# > 0 )) || { echo "script requires 1 argument"; exit 1 ; }
chk="$( cat $1 | perl -nle 'print "$.:$_" if /\r/' )"
if [[ "$chk" = '' ]];then
  echo "ok  $1"
else
  echo "NG  $1"
  echo "$chk"  |head -5 >&2
  echo 
  echo "$1 ‚ÉCR‚ª‘¶Ý‚µ‚Ü‚·"
  exit 1
fi
