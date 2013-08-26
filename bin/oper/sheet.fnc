#!/bin/sh -u
alias Reload='. sheet.fnc'
alias Fol='while read;do printf -v "${REPLY%:*}" "${REPLY#*:}";done'

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
    
    if (( $# > 0 ));then
      printf -- "${@}"
    else
      printf ''
    fi
  fi
  
  if [[ "$nflg" = 'off' ]];then
    echo
  fi
}

Input () {
  local prompt=${1:-''}
  local dflt=${2:-}

  # stty -echo
  local ans
  Echo   >&2
  if [[ $dflt != '' ]];then
    Echo  "# def ${prompt} : $dflt" >&2
  fi
  while((1==1));do
    Echo -n "Input ${prompt} > "  >&2
    read ans
    if [[ $ans = '' ]];then
      ans="$dflt"
    fi
    #
    if [[ $ans = '!!'* ]];then
      ans="${ans#!!}"
      if [[ $ans = '' ]];then
        return 1
      else
        Ask -r "eval $ans" || return 1
        eval "$ans" >&2
      fi
    else
      break
    fi
  done
  # stty echo
  
  Echo "$ans"
}

Ask () {
  typeset rflg=off
  if [[ "${1:-}" = '-r' ]];then
    rflg=on
    shift
  fi
  #
  local prompt=${1:-''}
  
  typeset ans
  Echo   >&2
  Echo -n "${prompt} ?[(y)es/(n)o] > "  >&2
  read  ans
  if [[ $ans = 'n'* ]];then
    if [[ "$rflg" = 'off' ]];then
      Echo 'n'
    else
      return 1
    fi
  else
    if [[ "$rflg" = 'off' ]];then
      Echo 'y'
    else
      return 0
    fi
  fi
}


Select () {
  local targ=${1:-''}
  shift
  local PS3="$( printf '\nSelect %s No. > ' "$targ" )"

  array=( "$@" )
 
  local ans
  Echo  >&2
  select ans in "${array[@]:-..}";do
    if [[ $REPLY = '!!'* ]];then
      local ans="${REPLY#!!}"
      if [[ $ans = '' ]];then
        return 1
      else
        Ask -r "eval $ans" || return 1
        eval "$ans" >&2
      fi
    else
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
    fi
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
  local tbl=$1
  shift
  
  eles=( $( head -1 $tbl ) )
  typeset -i n=0
  typeset -i c=0
  local cond='NR>2 '
  local vals=''
  for ele in ${eles[*]};do
    n=n+1
    if (( $# > 0 ));then
      val=$1
      shift
    else
      val=$( Select "$ele" $( awk " $cond {print \$$n} " $tbl | sort | uniq ) )
    fi
    if [[ $val != '' && $val != '*' ]];then
      cond="$cond && \$$n == \"$val\""
    fi
    #
    c=$( awk " $cond {print} " $tbl | wc -l )
    if (( $c == 0 ));then
      break
    elif (( $c == 1 ));then
      awk " $cond {print} " $tbl | sed 's/ //g'
      break
    fi
  done
}

Spass () {
  local category='OS'
  local group=''
  if [[ ${1:-} = '-db' ]];then
    category='DB'
    group=$2
    shift 2
  fi

  local host=$1
  local user=$2

  local eles=( $( SelTbl $CONFDIR/abc.hosts "$category" "$group" "$host" "$user" ) )
  echo "${eles[4]}"
}

Lsf () {
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

SetKey () {
  local eles=( $( SelTbl $CONFDIR/abc.hosts 'OS' ) )
  #
  Echo "${eles[3]}@${eles[2]}"
}

###
### Sheet
###
Set () {
  local eles=( $( SelTbl $CONFDIR/abc.hosts 'OS' ) )
  #
  host="${eles[2]}"
  user="${eles[3]}"
}

Ls () {
  local ropt=off
  if [[ ${1:-} = '-r' ]];then
    ropt=on
    shift
  fi
  #
  local prompt=${1:-'file'}
  local object=${2:-$( Select "$prompt" $( Lsf ) )}

  while((1==1));do
    local cont=$ropt
    #
    if [[ $object = '?'* ]];then
      Ask -r "Find '$object'" || return 1
      object=$( Select "$prompt" $( Find "${object#?}" ) )
    fi
    #
    if [[ "$object" = '' ]];then
      cont=off
    elif [ -d $object ];then
      cd $object
    else
      egrep --color '^[\$>_] ' $object
      _target="$object"
      cont=off
    fi
    #
    if [[ $cont = on ]];then 
      object=$( Select "$prompt" $( Lsf ) )
    else
      break
    fi
  done
}

Branch () {
  local sheet=${1:-${_target:-( Select 'sheet' $( Lsf ) )}}
  #
  local -i seqno=1
  local branch
  printf   -v 'branch' '%s-%02d.sheet' "${sheet%.sheet}" $seqno
  while [ -f $branch ];do
    seqno=$(( $seqno + 1 ))
    printf -v 'branch' '%s-%02d.sheet' "${sheet%.sheet}" $seqno
  done
  printf   -v 'branch' '%02d' $seqno
  #
  branch=${2:-$(  Input  'branch-no' "$branch" )}
  #
  branch="${sheet%.sheet}-${branch}.sheet"
  cp $sheet ${branch}
  ( edit $PWD/${branch} )&
  _target=$branch
}

Tel () {
  local today=$( date +'%Y%m%d' )
  mkdir -p $LOGSDIR/oper/${today}
  mkdir -p $LOGSDIR/oper/${today}/logs

  title='01'
  stxt="$LOGSDIR/oper/${today}/_${user}@${host}.txt"
  cat > ${stxt} <<-EOF
	#
	#@host: ${host}
	#@user: ${user}
	#@log: $LOGSDIR/oper/${today}/logs/${desc}_${user}@${host}.log
	#
	EOF
  if   [ -e $APPLDIR/sheets/$user@$host.sheet ];then
    .       $APPLDIR/sheets/$user@$host.sheet
  elif [ -e $APPLDIR/sheets/$host.sheet ];then
    .       $APPLDIR/sheets/$host.sheet
  else
    . $APPLDIR/sheets/00.sheet
  fi
  . $APPLDIR/sheets/01.sheet
  . $APPLDIR/sheets/99.sheet

  #
  ( /bin/mintty -t "${user}@${host} - ${title}"  telnet.pl $stxt )&
}

Make () {
  local sheet=${1:-${_target:-$( Select 'sheet' $( Lsf ) )}}
  local desc=${2:-$(  Input  'description'  )}
  
  Echo
  Echo "Host  : $host"
  Echo "User  : $user"
  Echo "Sheet : $sheet"
  Echo
  
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
  if [[ ${title} = '01' ]];then
    stxt="$LOGSDIR/oper/${today}/${desc}_${user}@${host}.txt"
  fi
  ###
  (
    while (( 1==1 ));do
      Echo
      if [[ ${title} = '01' ]];then
        cat > ${stxt} <<-EOF
			#
			#@host: ${host}
			#@user: ${user}
			#@log: $LOGSDIR/oper/${today}/logs/${desc}_${user}@${host}.log
			#
		EOF
      else
        cat > ${stxt} <<-EOF
			#
			#@host: ${host}
			#@user: ${user}
			#@log: $LOGSDIR/oper/${today}/logs/${hdr}_${title}${desc}_${user}@${host}.log
			#
		EOF
      fi
      if   [ -e $APPLDIR/sheets/$user@$host.sheet ];then
        .       $APPLDIR/sheets/$user@$host.sheet
      elif [ -e $APPLDIR/sheets/$host.sheet ];then
        .       $APPLDIR/sheets/$host.sheet
      else
        . $APPLDIR/sheets/00.sheet
      fi
      . $PWD/${sheet}
      . $APPLDIR/sheets/99.sheet

      cat ${stxt}
      Echo
      Echo "### created ${stxt}"
      Echo
      
      act=''
      while [[ $act = '' ]];do
        act=$( Select 'action' 're-create' 'rm' 'edit-sheet' 'edit-stxt' 'telnet' 'N/A' )
        if [[ "$act" = 'telnet' ]];then
          ( /bin/mintty -t "${user}@${host} - ${title}"  telnet.pl $stxt )&
          act=''
        fi
        if [[ "$act" = 'edit-sheet' ]];then
          ( edit $PWD/${sheet} )&
          act=''
        fi
        if [[ "$act" = 'edit-stxt' ]];then
          ( edit ${stxt} )&
          act=''
        fi
      done
      
      if [[ "$act" = 'N/A' ]];then
        eval ls -l '$stxt'
        break
      fi
      if [[ "$act" = 'rm' ]];then
        eval rm '$stxt'
        break
      fi
    done
  )
}

Find () {
  local keyword=${1:-''}
  keyword='^[\$>_] .*'"$keyword"

  find . -type f -name '*.sheet' | while read;do
#   Echo "egrep '$keyword' $REPLY" >&2
    rst="$( egrep "$keyword" "$REPLY" )"
    if [[ $rst != '' ]];then
      Echo >&2
      ls "${REPLY#./}"
      ls --color "${REPLY#./}"  >&2
      egrep --color -n "$keyword" "${REPLY#./}" >&2
    fi
  done
}

List () {
  local today=$( date +'%Y%m%d' )
  mkdir -p $LOGSDIR/oper/${today}

  local list=${1:-"$LOGSDIR/oper/$today"}
  
  mkdir -p  $list
  list=$( Select 'file/folder' $( Lsf $list ) )
  Echo "### $list"
  if [ -f "$list" ];then
    act=''
    while [[ $act = '' ]];do
      act=$( Select 'action' 'cat' 'rm' 'ls -l' 'telnet' 'noop' )
      if [[ "$act" = 'telnet' ]];then
        ( /bin/mintty -t "${list##*/}"  telnet.pl $list )&
        act=''
      fi
    done
    if [[ $act = 'noop' ]];then
      mv $list "${list%%_*}_noop.txt"
      echo "no operation" > "${list%%_*}_noop.txt"
    else
      eval $act '$list'
    fi
  fi
}
