unalias -a
shopt -s expand_aliases

#
# Dependency Var
#   LOGNAME
#   LOGFILE
#

# Color
readonly WHITE="\e[37m"
readonly RED="\e[31m"
readonly REDBLD="\e[31;1m"
readonly GREEN="\e[32m"
readonly YELLOW="\e[33m"
readonly BLUE="\e[34m"

readonly COLOFF="\e[m"

readonly CLR="\e[2J"

function Clear () {
  echo -e "$CLR"    >&3
  echo -e "\e[1;1H" >&3
}

# Logger
exec 3>&1

function Logger () {
  local    MLEVEL=$1
  local -i LINCNT=$2
  local    RAWMSG=$3

# printf "%s %-5s [%8d:%04d] %s\n" $(date +'%H:%M:%S') $MLEVEL $$ $LINCNT "$RAWMSG"
  printf "%s %-5s [%05d] %s\n" $(date +'%H:%M:%S') $MLEVEL $LINCNT "$RAWMSG" >> $LOGFILE
  
  if [[ $MLEVEL = 'INFO' ]];then
    echo -e "${WHITE}$RAWMSG${COLOFF}"   >&3
  elif [[ $MLEVEL = 'NOTE'  ]];then
    echo -e "${BLUE}$RAWMSG${COLOFF}"   >&3
  elif [[ $MLEVEL = 'SUCC'  ]];then
    echo -e "${GREEN}$RAWMSG${COLOFF}"   >&3
  elif [[ $MLEVEL = 'WARN'  ]];then
    echo -e "${YELLOW}$RAWMSG${COLOFF}"  >&3
  elif [[ $MLEVEL = 'ERROR' ]];then
    echo -e "${RED}$RAWMSG${COLOFF}"     >&3
  elif [[ $MLEVEL = 'FATAL' ]];then
    echo -e "${REDBLD}$RAWMSG${COLOFF}"  >&3
    exit 1
  fi
}
alias Info='Logger "INFO"  $LINENO'
alias Note='Logger "NOTE"  $LINENO'
alias Succ='Logger "SUCC"  $LINENO'
alias Warn='Logger "WARN"  $LINENO'
alias Erro='Logger "ERROR" $LINENO'
alias Die='Logger  "FATAL" $LINENO'

alias ERRON=$(
		cat <<-'_TEXT_'
			trap 'Die "Unexpected Problem : $?"' ERR
		_TEXT_
	)
alias ERROFF='trap "" ERR'

# Greeting
function PrevProc () {
  local _lineno=$1
  shift
  if [ -e $LOGFILE ];then
    Logger "WARN" $_lineno "現在、他のリリース処理が実行中です。"
    Logger "WARN" $_lineno "実行中の処理の情報は以下の通りです。"
    pwd
    head -6 $LOGFILE
    rm -f $LOGFILE
    exit 1
  else
    cat <<-__HEADER__ > $LOGFILE
		# PID  : $$
		# PPID : $PPID
		# $( ps -ef | egrep "\s+$$\s+$PPID\s+" )
		# Name : $APPLNAM
		# Lock : $LOGFILE
		#
	__HEADER__
  fi
}
function PostProc () {
  local _lineno=$1
  shift
  local rtns=( "$@" )
  #TODO
  mv $LOGFILE $DIAGDIR/$LOGNAME.log
  for rtn in ${rtns[@]};do
    (( rtn == 0 )) || {
      cat <<-__FOOTER__ >> $DIAGDIR/$LOGNAME.log
			##@ Statuses   : ${rtns[@]}
			##@ Forced Exit: $rtn  
		__FOOTER__

      echo
      echo "# ログ内容 - $DIAGDIR/$LOGNAME.log"
      echo
      cat  $DIAGDIR/$LOGNAME.log
      echo
      echo
      echo 'Release Procedure Forced Exit'
      echo
      echo -n "Please Input Retern : "
      read enter
      exit $rtn
    }
  done
}

alias Hello='PrevProc $LINENO  "$@"'
alias Bye='PostProc   $LINENO  "${PIPESTATUS[@]}"'

function RelInit () {
  ERRON
  Note "環境名称                $ENVNAM"
  Note "ホスト名                $( uname -n )"
  Note "実行ユーザ              $USERNAME"
  Note "サーバ種別              $SRVCOD"
  Note "DB環境設定ファイル      $DBENV"
  Note "リリース対象SID         $SID"
  Note "リリース対象フォルダ    $(pwd)"
  Note "リコンパイルオプション  $RECOMP"
  [ -e $CHKLST ] && rm -f $CHKLST
  [ -e $RESULT ] && rm -f $RESULT
  [ -e $REPORT ] && rm -f $REPORT
  [ -e $SQLON  ] && rm -f $SQLON
  if [[ $(ls) != "" ]];then
    for fn in $RELDIR/*;do
      if [[ "$fn" != "$RELDIR/*" ]];then
        rm -f $fn
      fi
    done
    Note "フォルダ内容"
    ls -la
  fi
  exit
}

function RelCheck () {
  ERRON
  local fln=$1

  if [ ! -e $RELDIR/$fln ];then
    Erro "NG  $fln は存在しません"
    echo "NG"  >> $RESULT
    continue
  fi

  ary=( $( wc $RELDIR/$fln ) )
  typeset -i tsiz=${ary[0]}+${ary[2]}
  if (( $siz == $tsiz ));then
    Succ "OK  $fln"
    echo "OK"  >> $RESULT
  else
    Warn "NG  $fln のファイルサイズが異なります(Win:$siz, Linux:${ary[0]}+${ary[2]})"
    echo "NG"  >> $RESULT
  fi
}

function Echo () {
  local msg=${1:-''}
  
  echo "$msg" >> $REPORT
}
function Cat () {
  local fln=$1
  
  cat $fln >> $REPORT
}

function RelRelease () {
  ERRON
  local fln=$1
  local sch=${2:-'.'}

  if [ ! -e $RELDIR/$fln ];then
    Erro "NG  $fln は存在しません"
    echo  "-	NG"  >> $RESULT
    continue
  fi

  # Release time set
  typeset tim="$(date +'%Y/%m/%d %H:%M:%S')"

  typeset -i errcnt=0

  # SQL
  if [[ "${tbl[SQL_${typ}]}" = 'on' ]];then
    if [[ ${sch:-'.'} = "." ]];then
      errcnt=-1
    elif [ ! -r $BASEDIR/job/pass/${sch} ];then
      errcnt=-2
    else
      typeset pass=$( cat $BASEDIR/job/pass/${sch} )
      if [ ! -e $SQLON ] && [[ ${RECOMP:-on} = 'on' ]];then
        :> $SQLON
      fi
      sqlplus $sch/$pass > $DIAGDIR/$$.tmp <<-EOF
		spool $DIAGDIR/$$.rst
		@$RELDIR/$fln
		spool off
		EOF
      errcnt=$( egrep  -e '^ORA-' -e '^CPY-' -e '^SP[0-9]-' -e '^Warning' -e '^Error' -e '  spool off' $DIAGDIR/$$.rst | wc -l )
      if (( $errcnt == 0 ));then
        errcnt=$( grep -e '^ORA-' -e '^CPY-' -e '^SP[0-9]-' -e '^Warning' -e '^Error' -e '  spool off' $DIAGDIR/$$.tmp | wc -l )
        if (( $errcnt > 0 ));then
          errcnt=-3
        fi
      fi

      Echo
      Echo "********************************************"
      Echo "* リリース $fln on $sch at $tim"
      Echo "********************************************"
      if ((  $errcnt < 0 ));then
        Cat   $DIAGDIR/$$.tmp
      else
        Cat   $DIAGDIR/$$.rst
      fi
      rm -f $DIAGDIR/$$.tmp
      rm -f $DIAGDIR/$$.rst
      Echo "********************************************"
      Echo
      Echo
    fi
  fi
  
  # MV
  typeset toDir="${tbl[MV_${typ}]}"

  if [[ "${tbl[SQL_${typ}]}" != 'on' ]];then
  #Info "mv $RELDIR/$fln $toDir"
      Echo "********************************************"
      Echo "* リリース $fln at $tim"
      Echo "********************************************" 
      Echo "mv $RELDIR/$fln $toDir"
      Echo "chmod 754 $toDir/$fln"
      Echo "********************************************" 
      Echo
   
      mv $RELDIR/$fln $toDir/
      chmod 754 $toDir/$fln
  else
     mv $RELDIR/$fln $toDir/
  fi

  if (( $errcnt == 0 ));then
    Succ  "OK  $fln"
    echo "$tim	OK" >> $RESULT
    return 0
  elif (( $errcnt == -1 ));then
    Erro "NG  $fln  スキーマが指定されていません"
    echo "$tim	NG" >> $RESULT
    return 1
  elif (( $errcnt == -2 ));then
    Erro "NG  $fln  $BASEDIR/job/pass/$sch が読めません"
    echo "$tim	NG" >> $RESULT
    return 1
  elif (( $errcnt == -3 ));then
    Erro "NG  $fln  sqlplus が異常終了しました"
    echo "$tim	NG" >> $RESULT
    return 1
  else
    Erro "NG  $fln  エラーが $errcnt 個見つかりました"
    echo "$tim	NG" >> $RESULT
    return 1
  fi
}

function RelReleaseAP () {
  ERRON
  local fln=$1
  local sch=${2:-'.'}

  if [ ! -e $RELDIR/$fln ];then
    Erro "NG  $fln は存在しません"
    echo  "-	NG"  >> $RESULT
    continue
  fi

  # Release time set
  typeset tim="$(date +'%Y/%m/%d %H:%M:%S')"

  # MV
  typeset toDir="${tbl[MV_${typ}]}"

  if [[ "${tbl[SQL_${typ}]}" != 'on' ]];then
  #Info "mv $RELDIR/$fln $toDir"
      Echo "********************************************"
      Echo "* リリース $fln at $tim"
      Echo "********************************************" 
      Echo "mv $RELDIR/$fln $toDir"
      Echo "chmod 754 $toDir/$fln"
      Echo "********************************************" 
      Echo
   
      mv $RELDIR/$fln $toDir/
      chmod 754 $toDir/$fln
      Succ  "OK  $fln"
      echo "$tim	OK" >> $RESULT
      return 0
  else
      mv $RELDIR/$fln $toDir/
      Succ  "N/A  $fln"
      echo "-	-" >> $RESULT
      return 0
  fi
}

function RelRecomp () {
  ERRON
  Echo
  Echo "********************************************"
  Echo "* 無効オブジェクトの再コンパイル"
  Echo "********************************************"

  sqlplus / as sysdba <<-EOS2
	set line 200
	set pagesize 1000
	spool $REPORT app
	execute UTL_RECOMP.recomp_parallel(4);
	spool off
	exit
	EOS2

  Echo "********************************************"
  Echo
  Echo
}

function RelObjStatus () {
  ERRON
  local msg=$1

  Echo
  Echo "********************************************"
  Echo "* $msg"
  Echo "********************************************"
  
  cat > $DIAGDIR/$$.sql <<-EOS
	set echo off
	set line 200
	col OBJECT_NAME format a60
	set pagesize 1000
	spool $REPORT app
	select OWNER,OBJECT_NAME,STATUS,OBJECT_TYPE,TIMESTAMP from dba_objects
	where  status <> 'VALID' and OBJECT_NAME like 'XX%' order by OBJECT_NAME;
	spool off
	exit
	EOS
  sqlplus / as sysdba @$DIAGDIR/$$.sql
  rm -f $DIAGDIR/$$.sql
  
  Echo "********************************************"
  Echo
  Echo
}

function RelObjError () {
  ERRON
  local msg=$1

  Echo
  Echo "********************************************"
  Echo "* $msg"
  Echo "********************************************"

  cat > $DIAGDIR/$$.sql <<-EOS3
	set echo off
	set line 200
	set pagesize 1000
	col OWNER format a10
	col NAME format a20
	col TYPE format a15
	col SEQUENCE for 999,999,999
	col LINE for 999,999,999
	col POSITION for 999,999,999
	col TEXT format a80
	col ATTRIBUTE format a15
	col MESSAGE_NUMBER for 999,999,999
	spool $REPORT app
	select * from dba_errors where NAME like '%XX%';
	spool off
	exit
	EOS3
  sqlplus / as sysdba @$DIAGDIR/$$.sql
  rm -f $DIAGDIR/$$.sql

  Echo "********************************************"
  Echo
  Echo
}
