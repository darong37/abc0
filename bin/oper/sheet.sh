#!/bin/sh -u
###
#@(#) Name         : oper/sheet.sh
###
typeset APPLDIR=$( cd $(dirname $0) && pwd )
typeset BASEDIR='../..'      # ベースフォルダの  APPLDIRからの相対パス
typeset CONFDIR='conf'       # 環境設定フォルダのBASEDIRからの相対パス
typeset DEFENVS=''           # include設定ファイル名,複数指定可(space区切)

. $APPLDIR/$BASEDIR/$CONFDIR/defenv

exec 3>&1

###
. $APPLDIR/sheet.fnc

###
export PS4='        +$LINENO	'
#IntHandler () {
#  Echo "handler"
#  local act=$( Select 'interrupt action' 'continue' 'exit' )
#  if [[ $act = 'exit' ]];then
#    exit
#  fi
#}
#trap 'echo "# you hit break!";IntHandler' INT

###
cd $APPLDIR
. $APPLDIR/.sheet

Hello
{
  ##
  # Constants & Alias
  #


  ##
  # Init Check
  #
# (( $# == 0 ))                        || Die  "script requires 1 argument only"         2

  ##
  #  Arguments & Variables
  #
  typeset _key=${1:-${_defkey:-$( Key )}}
  typeset _cdir=${2:-sheets}
  typeset _target=${3:-}
  typeset _asof=${4:-$( date +'%Y%m%d' )}

  ##
  # Procedures
  #
  cd $APPLDIR/$_cdir
  if ! tty -s;then exit;fi
  Asof $_asof
  
  # REPL
  while(( 0==0 ));do
    rst="$( jobs )"
    if [[ "$rst" != '' ]];then
      Echo "# jobs"
      Echo "$rst"
    fi
    Echo
    Echo "# asof  : $_asof"
    Echo "# key   : $_key"
    if [[ $_target != '' ]];then
      Echo "# target: $_target"
    fi
    #
    # REP
    #
#   ERROFF
      if _SUB="$( Repl "${PWD#$APPLDIR/}" )";then
        eval "$_SUB"
        typeset -i rtn=$?
        Echo
        Echo "--> $rtn"
      else
        Echo "XX: $_SUB"
      fi
#   ERRON
  done
} 2>&1 | tee -a $LOGFILE
Bye

##### Final
exit
