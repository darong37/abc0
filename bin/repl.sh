#!/bin/sh -u
typeset -i cnt=0
while(( cnt < 3 ));do
  read SUB?"REPL> "
  if [[ $SUB = '' ]];then
    cnt=cnt+1
  else
    cnt=0
    
    echo "#"
    echo "# $( date +"%H:%M:%S" ) $$"
    echo "#"
    echo "\$ $SUB"
    rtn=$( 
      eval "$SUB"
      echo "\n# -> $?"
    )
    echo "$rtn"
    echo ""
  fi
done
