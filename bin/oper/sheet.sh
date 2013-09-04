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
# typeset key=${1:-${defkey:-$( Key )}}
# typeset host=${key#*@}
# typeset user=${key%@*}
  typeset _key=${1:-${_defkey:-$( Key )}}
  typeset _cdir=${2:-sheets}
  typeset _asof=${3:-$( date +'%Y%m%d' )}

  ##
  # Procedures
  #
  cd $APPLDIR/$_cdir
  if tty -s;then
    typeset -i cnt=0
    typeset _target=''
    while(( cnt < 5 ));do
      typeset _prompt=${PWD#$APPLDIR/}
      Echo
      Echo "# key   : $_key"
      Echo "# asof  : $_asof"
      if [[ $_target != '' ]];then
        Echo "# target: $_target"
      fi
      Echo -n "$_prompt> "
      read _SUB
      Echo
      _SUB=$( echo $_SUB )
      
      if [[ "$_SUB" = *.sheet ]] && [ -f "$_SUB" ];then
        Ls ${_SUB##*/}
####
      elif [[ "$_SUB" = '?' ]];then
        Echo "# k: Key"
        Echo "# a: Asof"
        Echo "# t: Tel"
        Echo "# s: Sheet"
        Echo "# b: Branch"
        Echo "# l: Ls"
        Echo "#  : Ls"
        Echo "# e: exit"
      elif [[ "$_SUB" = 'k' ]];then
        Echo "# Key"
        Key
      elif [[ "$_SUB" = 'a' ]];then
        Echo "# Asof"
        Asof
      elif [[ "$_SUB" = 't' ]];then
        Echo "# Tel"
        Tel
      elif [[ "$_SUB" = 's' ]];then
        if [[ $_target = '' ]];then
          Ls -r 'sheet'
        fi
        Echo "# Sheet"
        Sheet
      elif [[ "$_SUB" = 'b' ]];then
        if [[ "$_target" = '' ]];then
          Ls -r 'sheet'
        fi
        Echo "# Branch"
        Branch
      elif [[ "$_SUB" = 'c' ]];then
        _target=''
      elif [[ "$_SUB" = 'l' ]];then
        Ls
      elif [[ "$_SUB" = '' ]];then
        Ls
####
      elif [[ "$_SUB" = 'exit' ]];then
        Echo "_defkey=$_key" > $APPLDIR/.sheet
        break
      else
        cnt=0
        ERROFF
          eval "$_SUB"
          typeset -i rtn=$?
          Echo
          Echo "--> $rtn"
          #
          rst="$( jobs )"
          if [[ "$rst" != '' ]];then
            Echo "# jobs"
            Echo "$rst"
          fi
        ERRON
      fi
    done
  fi
} 2>&1 | tee -a $LOGFILE
Bye

##### Final
exit

