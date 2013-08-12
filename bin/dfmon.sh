#!/bin/sh -u
typeset ADIR=$( cd $(dirname $0);pwd )

typeset slp=${1:-300}   # 


Df () {
  df -m | perl -ple 's/ƒuƒƒbƒN//' | 
    awk '{printf "%-18s\t%10s\t%10s\t%5s\n",$7,$2,$3,$4}' > $ADIR/cur.df

  du -m   /u02/p301/oracle/arch /u04/p358/oracle/arch | 
    awk '{printf "%-18s\t%10s\n",$2,$1}' > $ADIR/cur.du

  ls -ltr /u02/p301/oracle/arch > $ADIR/cur-p301.ls
  ls -ltr /u04/p358/oracle/arch > $ADIR/cur-p358.ls
}

Dif () {
  typeset cur=$2
  typeset prv=$3
  if ! diff -s $prv >&- $cur;then
    echo "$1 $(date +'%H:%M:%S')"
    diff $prv $cur                   # | egrep -e '^>'
    echo
  fi
}

Df
echo "# df $(date +'%H:%M:%S')"
cat $ADIR/cur.df
echo

echo "# du"
cat $ADIR/cur.du
echo

echo "# p301"
cat $ADIR/cur-p301.ls
echo

echo "# p358"
cat $ADIR/cur-p358.ls
echo

while (( 1 == 1 ));do
  sleep $slp
  mv $ADIR/cur.df $ADIR/prv.df
  mv $ADIR/cur.du $ADIR/prv.du
  mv $ADIR/cur-p301.ls $ADIR/prv-p301.ls
  mv $ADIR/cur-p358.ls $ADIR/prv-p358.ls
  Df
  #
  Dif "# df"   $ADIR/cur.df $ADIR/prv.df
  Dif "# du"   $ADIR/cur.du $ADIR/prv.du
  Dif "# p301" $ADIR/cur-p301.ls $ADIR/prv-p301.ls
  Dif "# p358" $ADIR/cur-p358.ls $ADIR/prv-p358.ls
done
