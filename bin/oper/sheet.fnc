#!/bin/sh -u
alias Reload='. sheet.fnc'

f_func () {
  local _FUNC=
  {
    echo
    echo '#? ファンクションの番号を選択してください'
    PS3='>> '
    select _FUNC in $( typeset -f |grep function |perl -ple 's/function //' ) n/a ;do
      echo
      break
    done
  } >&2
  
  if [[ $_FUNC = 'n/a' ]];then
    echo 'no select' >&2 
  else
    echo $_FUNC
  fi
}

Trace () {
  local _FUNC=${1:-$( Select 'Function'  )}

  local tron=$( typeset -ft |grep "$_FUNC" )
  if [[ "$tron" = "" ]];then
    typeset -ft $_FUNC
  else
    typeset +ft $_FUNC
  fi
}

###
Echo () {
  local nflg='off'
  
  if (( $# > 0 ));then
    if [[ "${1:-}" = '-n' ]];then
      shift
      nflg='on'
    fi
    
    printf "$@"
  fi
  
  if [[ "$nflg" = 'off' ]];then
    echo
  fi
}

Input () {
  local prompt=${1:-''}

  # stty -echo
  local ans
  Echo   >&2
  Echo -n "Input ${prompt} > "  >&2
  read ans
  # stty echo
  
  Echo "$ans"
}

Input3 () {
  local prompt=${1:-''}

  # stty -echo
  local ans
  Echo   >&2
  Echo -n "Input ${prompt}> "  >&2
  read ans
  # stty echo
  
  printf "# '%s' : $ans\n" "${prompt}" >&3
  Echo "$ans"
}

Select () {
  if [[ ${1:-''} = '-h' ]];then
    cat <<-'USAGE'
		usage: Select $prompt @choices
		       Select $prompt -c @command-strings
		       Select $prompt -f $file-name
		option
		  -d : default value
		  -c : command 
		  -f : file contents
	USAGE
	return 0
  fi
  
  local targ=${1:-''}
  shift
  local PS3="$( printf '\nSelect %s No. > ' "$targ" )"

  # choices
  if   [[ $1 = '-f' ]];then
    array=( $( cat $2 ) )
  elif [[ $1 = '-c' ]];then
    shift
    array=( $( $@ ) )
  else
    array=( "$@" )
  fi
 
  local ans
  Echo  >&2
  select ans in "${array[@]:-..}";do
    if [[ $REPLY = '' ]];then
      Echo "Default $defv"
      break
    fi
    if [[ ${ans} = '' ]];then
      for no in $REPLY;do
        if perl -e "exit 1 unless '$no'=~/^[0-9]+\$/";then
          no=$(( $no - 1 ))
          Echo "${array[$no]}"
        else
          Echo "${no}"
        fi
      done
    else
      Echo $ans
    fi
    break
  done
  return 0
}

Col () {
  local cno=$1
  local tbl=${2:-}
  
  awk '{print $'$cno' }' $tbl
}

Row () {
  local rno=$1
  local tbl=${2:-}
  
  awk 'NR=='$rno $tbl
}

SelTbl () {
  local dispcol=$1
  local rtncol=$2
  local tbl=$3

  local buf="$(egrep -v '^#' $tbl)"
  
  local rowno
  select ans in $(echo "$buf" | Col $dispcol );do
    rowno=$( echo $REPLY )
    break
  done
  
  echo "$buf" | Row $rowno | Col $rtncol
}

Lsf () {
  if [[ ${1:-} = '-u' ]];then
    Echo '..'
    shift
  fi
  typeset stock=''
  ls -1F "$@" | {
    while read;do
      if [[ "$REPLY" = *'/' ]];then
        Echo $REPLY
      else
        stock="$stock$( Echo "${REPLY%'*'}" )
"
      fi
    done
    Echo "$stock"
  }
}

Filer () {
  local prompt=${1:-''}
  local target=${2:-.}

  while [ ! -f "$target" ];do
    Echo "### $target" >&2
    if [ -d "$target" ];then
      target="${target%/}/$( Select "$prompt" -c Lsf -u $target )"
      target="${target%/*/..}"
    fi
  done

  if [ -f "$target" ];then
    eval Echo "'$target'"
  fi
}

### Sheet

Create () {
  local sheet=${1:-$( Filer  'sheet' sheets )}
  local desc=${2:-$(  Input  'description'  )}
# local conn=${3:-$(  Select 'Connect' -c Col -d ':' 1,2 $CONFDIR/abc.hosts )}
  local conn=${3:-$(  Select 'Connect' $( awk '/^[^#]/{print $2 ":" $3}' $CONFDIR/abc.hosts ) )}
# local host=${3:-$(  Select 'Host-Name'    -f sheet.hosts )}
  local host=${conn%:*}
# local user=${4:-$(  Input  'OS User-Name' )}
  local user=${conn#*:}
  
  local today=$( date +'%Y%m%d' )
  mkdir -p $LOGSDIR/oper/${today}
  mkdir -p $LOGSDIR/oper/${today}/logs

  title=${sheet%.sheet}
  title=${title##*/}
  if [[ $desc != '' ]];then
    desc="-$desc"
  fi
  Echo "\n### Title: $title"
  ### 
  typeset -i seqno=1
  typeset hdr
  printf -v 'hdr' '%08d-%03d' "${today}" $seqno
  
  while [ -f $LOGSDIR/oper/${today}/${hdr}* ];do
    seqno=$(( $seqno + 1 ))
    printf -v 'hdr' '%08d-%03d' "${today}" $seqno
  done
  
  typeset stxt="$LOGSDIR/oper/${today}/${hdr}_${title}${desc}_${user}@${host}.txt"
  ###
  
  while (( 1==1 ));do
    Echo
    cat > ${stxt} <<-EOF
		#
		#@host: ${host}
		#@user: root
		#@log: $LOGSDIR/oper/${today}/logs/${hdr}_${title}${desc}_${user}@${host}.log
		#
	EOF
    . sheets/00.sheet
    . ${sheet}
    . sheets/99.sheet
    
    Echo
    Echo "### created ${stxt}"
    Echo
    cat ${stxt}
    
    act=$( Select 'action' 're-create' 'rm' 'N/A' )
    if [[ "$act" = 'N/A' ]];then
      eval ls -l '$stxt'
      break
    fi
    if [[ "$act" = 'rm' ]];then
      eval rm '$stxt'
      break
    fi
  done
}

List () {
  local today=$( date +'%Y%m%d' )
  mkdir -p $LOGSDIR/oper/${today}

  local target=${1:-"$LOGSDIR/oper/$today"}
  
  mkdir -p  $target
# while [ ! -f "$target" ];do
#   if [ -d "$target" ];then
#     target="${target%/}/$( Select 'file/folder' -c ls $target )"
#     target=${target%/*/..}
#   else
#     Echo "not found $target"
#     break
#   fi
  target = $( Filer 'file/folder' $target )
    Echo "### $target"
# done
  if [ -f "$target" ];then
    act=$( Select 'action' 'cat' 'rm' 'ls -l' 'noop' )
    if [[ $act = 'noop' ]];then
      mv $target "${target%%_*}_noop.txt"
      echo "no operation" > "${target%%_*}_noop.txt"
    else
      eval $act '$target'
    fi
  fi
}
