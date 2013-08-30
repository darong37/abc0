#!/bin/sh -u
  typeset opt_c=''
  typeset opt_f=''
  typeset opt_p=''
  while getopts "cf:p:" opts; do
    echo "==== $opts"
    case $opts in
      c) opt_c='true';;
      f) opt_f="$OPTARG";;
      p) opt_p="$OPTARG";;
    esac
  done
  shift $(( $OPTIND - 1 ))
  
  ##
  echo "c: $opt_c"
  echo "f: $opt_f"
  echo "p: $opt_p"
 
exit
while getopts ":abc" opts
do
  case $opts in
    a)      echo a      ;;
    b)      echo b      ;;
    c)      echo c      ;;
  esac
done
