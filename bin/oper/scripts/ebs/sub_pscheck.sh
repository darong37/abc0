#!/usr/bin/ksh -u
######################################################################
#@(#) Project        : EBS Version up Project
#@(#) Team           : Infrastructure
#@(#) Name           : sub_pscheck.sh
#@(#) Function       : print Top Processes Report for DB.
#@(#) Version        : v.1.1.0
#@(#) Usege          : sub_pscheck.sh
#@(#) Return code    : 
#@(#)                  0  : Successful completion.
#@(#)                  >0 : An error condition occurred.
#@(#) Host           : AIX
#@(#) ACL            : root / sys / 0700
#@(#) Relation file  : 
#@(#) Notes          : 
#@(#)
######################################################################
#@(#) Revision history
#@(#) Date             Developer/Corrector Description
#@(#) ________________ ___________________ ___________________________
#@(#) 2013/02/20       E.Yoshida           New
######################################################################

######################################################################
# Initialization
######################################################################
typeset APPLDIR=$( cd $(dirname $0) && pwd )
typeset BASEDIR='../..'                # ベースフォルダの  APPLDIRからの相対パス
typeset CONFDIR='scripts/ENV'          # 環境設定フォルダのBASEDIRからの相対パス
typeset DEFENVS='common.env'           # CONFDIR内の環境設定ファイル名,複数可(space区切)
export  EXPOPRM='nolog'

. $APPLDIR/$BASEDIR/$CONFDIR/DefEnv
######################################################################
# Main Brace
######################################################################
cd  $WRK_DIR
{
  # Info "start  Log : $LOGFILE"

  ##
  # Arguments & Constants
  #
  typeset -i silent
  typeset    _role=''
  while getopts 'ads' opt ; do
    case $opt in
    a)    _role='ap' ;;
    d)    _role='db' ;;
    s)    silent=1   ;;
    esac
  done
  shift $(($OPTIND -1))

  # Options
  readonly silent=${silent:-0}
  Echo () {
    (( silent == 0 )) && echo "${@:-}"
  }
  Banner () {
    (( silent == 0 )) && banner "${@:-}"
  }

  # Arguments
  (( $# == 1 ))                        || Die  "script requires 1 argument only"         1
  readonly _SID="${1}"
  
  # Constants
  readonly _KEY_DIV=$(
    if [[ "${_role}"   == 'ap' ]];then
      echo "EBS_APPL"
    elif [[ "${_role}" == 'db' ]];then
      echo "EBS_DB"
    elif [[ "${SRVROLE}" == 'AP' ]];then
      echo "EBS_APPL"
    else 
      echo "EBS_DB"
    fi 
  )
  readonly _HOST_NAME="$(uname -n)"
  readonly _USER="ora${_SID}"
  
  ##
  # Checks
  #
  [[ $(id -u)  -eq 0 ]]                || Die  "$(id -un) can not run (root only)"       2
  
  ##
  # Procedures
  #
  typeset _G01 _G02 _G03 _G04 _G05 _G06 _G07
  fa_get_data_from_common_list -n "${_HOST_NAME}" -d "${_KEY_DIV}" -v "${_SID}" |
    read _G01 _G02 _G03 _G04 _G05 _G06 _G07 _VERSION _HOME_ENV_CHOICE _TNSLSNR_ARG _DAEMONS
  
# echo "_VERSION: $_VERSION"
# echo "_HOME_ENV_CHOICE: $_HOME_ENV_CHOICE"
# echo "_TNSLSNR_ARG: $_TNSLSNR_ARG"
# echo "_DAEMONS: $_DAEMONS"
  
  if (( silent == 0 ));then
    fa_confirm_daemon_running -u "${_USER}" ${_DAEMONS}
  else
    fa_confirm_daemon_running -u "${_USER}" ${_DAEMONS} > /dev/null
  fi
  typeset -i rtn1=$?
  (( rtn1 == 0 )) || Echo ""
  
  if (( silent == 0 ));then
    fa_confirm_tnslsnr_running -u "${_USER}" "${_TNSLSNR_ARG}"
  else
    fa_confirm_tnslsnr_running -u "${_USER}" "${_TNSLSNR_ARG}" > /dev/null
  fi
  typeset -i rtn2=$?
  (( rtn2 == 0 )) || Echo "+++ ERROR: tnslsnr ${_TNSLSNR_ARG} not found."
  
  if (( rtn1 == 0 && rtn2 == 0 )); then
    Echo
    Echo "all process running."
    exit 0
  else
    Echo
    Echo
    Banner "WARNING"
    Echo
    exit 1
  fi

  # if used temporary file
  # rm "${TMPFILE}"                    || Warn "can not remove temporary-file"

  # Info "finish" 0 -syslog
}
# Copy to Historical Log if needed.
# cp -p $LOGFILE $LOGHIST                || Warn "can not copy historical-log"

exit
