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
  typeset key=${1:-${defkey:-$( SetKey )}}
  typeset host=${key#*@}
  typeset user=${key%@*}
  typeset _cdir=${2:-sheets}

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
      Echo "# $user@$host"
      if [[ $_target != '' ]];then
        Echo "# _target: $_target"
      fi
      Echo -n "$_prompt> "
      read _SUB
      Echo
      _SUB=$( echo $_SUB )
      
      if [[ "$_SUB" = *.sheet ]] && [ -f $_SUB ];then
        Ls ${_SUB##*/}
####
      elif [[ "$_SUB" = '?' ]];then
        Echo "# s: Set"
        Echo "# m: Make"
        Echo "# b: Branch"
        Echo "# l: Ls"
        Echo "#  : Ls"
        Echo "# e: exit"
      elif [[ "$_SUB" = 's' ]];then
        Echo "# Set"
        Set
      elif [[ "$_SUB" = 't' ]];then
        Echo "# Tel"
        Tel
      elif [[ "$_SUB" = 'm' ]];then
        if [[ $_target = '' ]];then
          Ls -r 'sheet'
        fi
        Echo "# Make"
        Make
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
        Echo "defkey=$user@$host" > $APPLDIR/.sheet
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

