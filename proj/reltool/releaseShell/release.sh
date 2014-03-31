#!/bin/sh -u
#	Usage
#		release.sh $OPR $CHKLST
#			OPR    :	Procedure
#				   :=	INIT|CHECK|RELEASE
#
#			CHKLST :	check list name
#				   :-	'.checklist'
#
readonly OPR=$1
typeset  CHKLST=${2:-'.checklist'}

#
# Base
#
readonly APPLNAM=$( basename $0 '.sh' )
readonly APPLDIR=$( cd $(dirname $0)  && pwd )
readonly BASEDIR=$( cd $APPLDIR/../.. && pwd )
readonly CNSTDIR=$( cd $APPLDIR/..    && pwd )
readonly DIAGDIR="$CNSTDIR/tmp"


#
# Const
#
readonly USERID=`whoami`
readonly LOGNAME="$APPLNAM"_"$USERID"
readonly LOGFILE="$DIAGDIR/$LOGNAME.lock"

readonly USERNAME=$( id -un )
readonly RELDIR="$CNSTDIR/$USERNAME"

readonly CHKLST="$RELDIR/$CHKLST"


#
# Check List Parameters
#
typeset  ENVNAM=$( egrep '^##ENVNAM:' $CHKLST )
typeset  SID=$(    egrep '^##SID:'    $CHKLST )
typeset  RECOMP=$( egrep '^##RECOMP:' $CHKLST )
typeset  SRVCOD=$( egrep '^##SRVCOD:' $CHKLST )
typeset  RESULT=$( egrep '^##RESULT:' $CHKLST )
typeset  REPORT=$( egrep '^##REPORT:' $CHKLST )

readonly ENVNAM="${ENVNAM%#ENVNAM:}"
readonly SID="${SID%#SID:}"
readonly RECOMP="${RECOMP%##RECOMP:}"
readonly SRVCOD="${SRVCOD%##SRVCOD:}"
readonly RESULT="$RELDIR/${RESULT%##RESULT:}"
readonly REPORT="$RELDIR/${REPORT%##REPORT:}"

readonly SQLON="$RELDIR/.sqlon"


#
# Read Function
#
readonly DBENV="/home/${USERNAME}/db.env"

[ -r $APPLDIR/$APPLNAM.fnc ] && . $APPLDIR/$APPLNAM.fnc
[ -r $DBENV                ] && . $DBENV

# Table
declare -A tbl
typeset    keynam subnam val
while read keynam subnam val;do
  [[ "$keynam" = ""   ]] && continue
  [[ "$keynam" = '#'* ]] && continue
  
  typeset varmam
  printf -v 'varnam' 'tbl[%s_%s]' "$keynam" "$subnam"
  printf -v "$varnam" "%s" "$val"
done < $APPLDIR/$APPLNAM.tbl
unset      keynam subnam val

# Init
if [[ $OPR = 'DEBUG' ]];then
  echo "Param  : $@"
  typeset -f | fgrep '()'
  exit
fi


# Main
cd $RELDIR
Hello
{
  ERRON
  Clear
  Info "Release Procedure Start - $OPR"
  Info ""
  [[ $RELDIR = $( pwd ) ]] || Die "フォルダ '$RELDIR' に移動できません$( pwd )"
  
  if [[ $OPR = 'INIT' ]];then
    RelInit
  fi
  
  [ -r $CHKLST ]           || Die "チェックリストがありません"
  :> $RESULT
  :> $REPORT
  if [[ $OPR = 'RELEASE' ]] && [[ ${SRVCOD:ap} = 'db'  ]];then
    #
    # Invalid Object一覧
    #
    RelObjStatus "リリース前 Invalid Objects" > /dev/null
  fi
  
  typeset fln
  typeset -i siz
  typeset -i typ
  typeset schema
  
  typeset -i oks=0
  while read fln siz typ schema;do
    if [[ $fln != '#'* ]];then
      if [[ $OPR = 'CHECK' ]];then
         RelCheck $fln
      elif [[ $OPR = 'RELEASE' ]];then
       if [[ ${SRVCOD:ap} = 'db'  ]];then
         if RelRelease $fln ${schema:-'.'} >> $LOGFILE 2>&1 ;then
           oks=oks+1
         fi
       else
         if RelReleaseAP $fln ${schema:-'.'} >> $LOGFILE 2>&1 ;then
           oks=oks+1
         fi
       fi
      fi
    fi
  done < $CHKLST
  
  if [[ $OPR = 'RELEASE' ]] && [[ ${SRVCOD:ap} = 'db'  ]];then
    if [ -e $SQLON ];then
      #
      # リコンパイル
      #
      Note ""
      Note "無効オブジェクト再コンパイル中 しばらくお待ちください"
      Note "再コンパイルに時間かかる場合があります。"
      Note "終了するまでセッションを切らないでください。"
      if [[ ${DEBUG:-off} = 'ON' ]];then
        Warn "デバッグモードでは実行されません"
      else
        RelRecomp               >> $LOGFILE
      fi
      Note ""
      Note "再コンパイル終了"
    fi

    #
    # Invalid Object一覧
    #
    RelObjStatus "リリース後 Invalid Objects" > /dev/null # >> $LOGFILE
    
    iconv -f UTF8 -t SJIS $REPORT > $DIAGDIR/$$.tmp
    mv -f $DIAGDIR/$$.tmp $REPORT
    #
    # package error一覧
    #
    RelObjError "package error [xx]Object" > /dev/null # >> $LOGFILE
  fi
  
  Info ""
  ERROFF
} 2>&1 | tee -a $LOGFILE
Bye
#
if [[ $OPR != 'INIT' ]] || [[ ${DEBUG:-off} = 'ON' ]];then
  echo
  echo
  echo -n "Please Input Retern : "
  read enter
fi
echo
echo
echo "Release Procedure Finished"
echo
echo "# ログ内容 - $DIAGDIR/$LOGNAME.log"
echo
cat  $DIAGDIR/$LOGNAME.log
echo
exit
