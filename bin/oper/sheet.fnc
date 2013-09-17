#!/bin/sh -u
#alias Reload='. sheet.fnc'
#alias Fol='while read;do printf -v "${REPLY%:*}" "${REPLY#*:}";done'

#f_func () {
#  local _FUNC=
#  {
#    echo
#    echo '#? ファンクションの番号を選択してください'
#    PS3='>> '
#    select _FUNC in $( typeset -f |grep function |perl -ple 's/function //' ) n/a ;do
#      echo
#      break
#    done
#  } >&2
#  
#  if [[ $_FUNC = 'n/a' ]];then
#    echo 'no select' >&2 
#  else
#    echo $_FUNC
#  fi
#}

#Trace () {
#  local _FUNC=${1:-$( Select 'Function'  )}
#
#  local tron=$( typeset -ft |grep "$_FUNC" )
#  if [[ "$tron" = "" ]];then
#    typeset -ft $_FUNC
#  else
#    typeset +ft $_FUNC
#  fi
#}

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
    printf "\n"
  fi
}

Repl () {
  local prompt=$1
  #
  local cmd
  Echo -n "$prompt > " >&2
  read  cmd
  cmd=$( echo $cmd )
  #
  case "$cmd" in
  '?')
      Echo "# a: Asof"   >&2
      Echo "# k: Key"    >&2
      Echo "# c: Clear"  >&2
      Echo "# e: Edit"   >&2
      Echo "# s: Sheet"  >&2
      Echo "# b: Branch" >&2
      Echo "# q: break"  >&2
      ;;
  a)  Echo "Asof"        ;;
  k)  Echo "Key"         ;;
  c)  Echo "_target=''"  ;;
  e)  Echo "Edit"        ;;
  s)  Echo "Sheet"       ;;
  b)  Echo "Branch"      ;;
  q)  Echo "break"       ;;
  '')
      if [[   $_target = '' ]];then
        Echo "Ls"
      elif [[ $_target = *.sheet ]];then
        Echo "Sheet"
      elif [[ $_target = *.task ]];then
        Echo "Task"
      fi
      ;;
  *)  Echo "$cmd"   ;;
  esac
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
    if [[ $ans = '??' ]];then
      ans="$( SelTbl $APPLDIR/sheet.prms | awk '{print $4}' )"
      Echo "${prompt} : '$ans'"   >&2
    fi
    if [[ $ans = '.' ]];then
      return 1
    fi
    if [[ $ans = '' ]];then
      ans="$dflt"
    fi
    #
    if [[ $ans = '!!'* ]];then
      ans="${ans#!!}"
      if [[ $ans = '' ]];then
        return 1
      else
        Ask -r "eval $ans" >&- || return 1
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
  local yes=${2:-'y'}
  
  typeset ans
  Echo   >&2
  Echo -n "${prompt} ?[y/n] > "  >&2
  read  ans
  if [[ $ans = 'n'* ]];then
    if [[ "$rflg" = 'on' ]];then
      return 1
    fi
  else
    Echo "$yes"
    if [[ "$rflg" = 'on' ]];then
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
  if (( ${#array[*]} == 0 ));then
    ans="$( Input "new ${targ}" '' )"
    Echo "$ans"
  else
    select ans in "${array[@]}";do
      if [[ $REPLY = '!!'* ]];then
        local ans="${REPLY#!!}"
        if [[ $ans = '' ]];then
          return 1
        else
          Ask -r "eval $ans" >&- || return 1
          eval "$ans" >&2
        fi
      elif [[ $REPLY = '.' ]];then
        return 1
      else
        if [[ ${ans} = '' ]];then
          for no in "$REPLY";do
            if perl -e "exit 1 unless '$no'=~/^[0-9]+\$/";then
              no=$(( $no - 1 ))
              Echo "${array[$no]}"
            else
              Echo "${no}"
            fi
          done
        else
          Echo "$ans"
        fi
        break
      fi
    done
  fi
  return 0
}

SelTbl () {
  local flgU='off'
  if [[ $1 = '-u' ]];then
    flgU='on'
    shift
  fi
  #
  local tbl=$1
  shift
  
  eles=( $( head -1 $tbl ) )
  typeset -i c=0
  typeset -i n=0
  local cond='/^[^#]/'
  local precond='/^[^#]/'
  local vals=''
  for ele in ${eles[*]};do
    n=n+1
    #
    if [[ $ele = '#'* ]];then
      if (( $# > 0 ));then
        val=$1
        shift
      else
        local choice="$( awk " $cond {print \$$n} " $tbl | sort | uniq )"
        if [[ $choice = '' ]];then
          choice="$( awk " $precond {print \$$n} " $tbl | sort | uniq )"
          val=$( Select "new $ele" $choice )
        else
          precond="$cond"
          val=$( Select "$ele" $choice )
        fi
      fi
      #
      if [[ $vals = '' ]];then
        vals="$val"
      else
        vals="$vals	$val"
      fi
      if [[ $val = '*' ]];then
        cond="$cond && \$$n ~ /.*/"
      else
        cond="$cond && \$$n == \"$val\""
      fi
    else
      c=$( awk " $cond {print} " $tbl | wc -l )
      if (( $c == 0 ));then
        val="$( Input "$ele" )"
        vals="$vals	$val"
      else
        # TBLに存在するデータの場合
        awk " $cond {print} " $tbl | sed 's/ //g'
        return 0
      fi
    fi
  done
  # TBLに存在しないデータの場合
  Echo "$vals"
  if [[ $flgU = 'on' ]];then
    cp -p ${tbl} ${tbl}.tmp
    if [ ! -e ${tbl}.$( date +'%Y%m%d' ) ];then
      cp -p ${tbl} ${tbl}.$( date +'%Y%m%d' )
    fi
    Echo "$vals" >> ${tbl}.tmp
    AnlTbl ${tbl}.tmp > ${tbl}
    rm ${tbl}.tmp
    diff ${tbl}.$( date +'%Y%m%d' ) ${tbl}
  fi
}

AnlTbl () {
  local tbl=$1
  local line=''
  typeset -i lno=0
  typeset -i idx=0
  maxs=()
  while read line;do
    lno=lno+1
    if [[ $line != '#'* ]] || (( lno == 1 ));then
      idx=0
      for ele in $line;do
        typeset -i len=${#ele}
        typeset -i max=${maxs[$idx]:-0}
        if (( len > max ));then
          maxs[$idx]=$len
          printf "Line %03d.   maxs[%d] -> %2d\n" $lno $idx "${maxs[$idx]}" >&2
        fi
        idx=idx+1
      done
    fi
  done < $tbl
  #
  Echo >&2
  typeset fmt=''
  typeset -i max=0
  eles=( $( head -1 $tbl ) )
  idx=0
  for max in ${maxs[*]};do
    typeset -i prty=$(( $max/4 * 4 ))
    if (( $max > $prty ));then
      prty=prty+4
    fi
    #
    printf "%2d. %-16s : %3d  -> %3d\n" $idx "${eles[$idx]}" $max $prty >&2

    idx=idx+1
    if (( $idx == ${#maxs[*]} ));then
      if [[ $fmt = '' ]];then
        fmt="%s"
      else
        fmt="${fmt}\t%s"
      fi
    else
      if [[ $fmt = '' ]];then
        fmt="%-${prty}s"
      else
        fmt="${fmt}\t%-${prty}s"
      fi
    fi
  done
  #
  Echo >&2
  Echo "%s\n" "Format : '$fmt'" >&2
  #
  Echo "Pretty Format" >&2
  lno=0
  while read line;do
    lno=lno+1
    if [[ $line != '#'* ]] || (( lno == 1 ));then
      eles=( $line )
      printf "${fmt}\n" "${eles[@]}"
    else
      Echo "$line"
    fi
  done < $tbl
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

Edit () {
  local fln=${1:-$( Ask -r "edit $_target" "$_target" || Select 'edit' $( Lsf ) )}
  #
  if [ ! -e $fln ];then
    ful=$( echo $PWD/$fln )
    Echo "Edit $ful ( $( ConvPath -r "$ful" ) )"
    ( edit "$( ConvPath -r "$ful" )" )&
    wait
  fi
}

Adjust () {
  local ind=${1:-'  '}
  perl -pe "s/^${ind}//"
}

###
### Sheet
###
Asof () {
  local asof=${1:-$( Input 'as of date' "$( date +'%Y%m%d' )" )}
  _asof="$asof"
  
  mkdir -p $LOGSDIR/oper/${_asof}
  mkdir -p $LOGSDIR/oper/${_asof}/logs
}

Key () {
  local eles=( $( SelTbl $CONFDIR/abc.hosts 'OS' ) )
  #
  Echo "${eles[3]}@${eles[2]}"
  _key="${eles[3]}@${eles[2]}"
  Echo "_defkey=$_key" > $APPLDIR/.sheet
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
      Ask -r "find '$object'" || return 1
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
  
  if [[ "$sheet" = *'-[0-9][0-9].sheet' ]];then
     sheet="${sheet%-[0-9][0-9].sheet}.sheet"
  fi
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
  local stxt=${1:-$( Select 'Sheet' $( Lsf $LOGSDIR/oper/$_asof/*.stxt ) )}
  
  Echo
  Echo "Stxt  : $stxt"
  local shead=$( basename $stxt .stxt )
  shead=${shead##*_}
  Echo "Shead : $shead"
  
  local logf=$( dirname $stxt )
  logf="${logf}/logs/$( basename $stxt '.stxt' ).log"
  Echo "# logf  : $logf"

  ( /bin/mintty -t "$shead - Tel"  telnet.pl $stxt  )&
}

Sheet () {
  local sheet=${1:-$( Ask -r "Sheet: ${_target:-01.sheet}" "${_target:-01.sheet}" || Select 'sheet' $( Lsf ) )}
  local key=${2:-$(   Ask -r "Key: $_key" "$_key" || Key )}
  local desc=${3:-}
  local host=${key#*@}
  local user=${key%@*}
  ###
  (
    while (( 1==1 ));do
      typeset -i seqno=1
      typeset hdr=${desc}
      if [[ $hdr = '' ]];then
        printf -v 'hdr' '%08d-%03d' "${_asof}" $seqno
        
        while [ -f $LOGSDIR/oper/${_asof}/${hdr}* ];do
          seqno=$(( $seqno + 1 ))
          printf -v 'hdr' '%08d-%03d' "${_asof}" $seqno
        done
      fi
      typeset stxt="$LOGSDIR/oper/${_asof}/${hdr}_${sheet%.sheet}_${user}@${host}.stxt"
      if [[ ${sheet} = '01.sheet' ]];then
        stxt="$LOGSDIR/oper/${_asof}/_${user}@${host}.stxt"
      fi
      ##
      key=${key:-$_key}
      host=${key#*@}
      user=${key%@*}
      Echo ""

      # Set sheet.prms
      while read var val;do
        if [[ "$var" != '*' ]];then
          printf -v "$var" "$val"
          eval echo "$var: \$$var"
        fi
      done <<-EOS
		$( SelTbl $APPLDIR/sheet.prms  "$host"  "$user" '*' | awk '{print $3,$4}' )
		EOS
      Echo ""
      
      if [[ ${sheet} = '01.sheet' ]];then
        cat > ${stxt} <<-EOF
			#@host: ${host}
			#@user: ${user}
			#@logf: $LOGSDIR/oper/${_asof}/logs/_${user}@${host}.log
			#@sheet: $PWD/${sheet}
		EOF
      else
        cat > ${stxt} <<-EOF
			#@host: ${host}
			#@user: ${user}
			#@logf: $LOGSDIR/oper/${_asof}/logs/${hdr}_${sheet%.sheet}_${user}@${host}.log
			#@sheet: $PWD/${sheet}
		EOF
      fi
      . $APPLDIR/sheets/00.sheet
      rtn=${?}
      if (( $rtn == 0 ));then
        if [[ ${sheet} = '01.sheet' ]];then
          . $APPLDIR/sheets/01.sheet
        else
          . $PWD/${sheet}
        fi
        rtn=${?}
        if (( $rtn == 0 ));then
          . $APPLDIR/sheets/99.sheet
          rtn=${?}
          if (( $rtn == 0 ));then
            cat ${stxt}
          else
            Echo "Error 99.sheet"
          fi
        else
          Echo "Error ${sheet}"
        fi
      else
        Echo "Error 00.sheet"
      fi

      Echo
      Echo "Key   : '$key'"
      Echo "Host  : '$host'"
      Echo "User  : '$user'"
      Echo "Sheet : '$sheet'"
      Echo "Stxt  : '${stxt}'"
      Echo
      
      act=''
      while [[ $act = '' ]];do
        act=$( Select 'action' 're-create' 'telnet' 'edit-sheet' 'edit-stxt' 'rm' 'N/A' )
        if [[ "$act" = 'telnet' ]];then
          Tel $stxt
          act=''
        fi
        if [[ "$act" = 'edit-sheet' ]];then
          if [[ "$sheet" = '01.sheet' ]];then
            sheet=$( Input 'new sheet name' )
            while [ -e $PWD/${sheet} ];do
              sheet=$( Input 'new sheet name' )
            done
            sheet="${sheet%.sheet}.sheet"
            cp $APPLDIR/sheets/01.sheet $PWD/${sheet}
          fi
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
      if [[ "$act" = 're-create' ]];then
        if [ -e $stxt ];then
          eval rm '$stxt'
        fi
      fi
      if [[ "$act" = 'rm' ]];then
        if [ -e $stxt ];then
          eval rm '$stxt'
        fi
        break
      fi
    done
  )
}

Find () {
  local keyword=${1:-''}
  keyword='^[\$>_] .*'"$keyword"

  find . -type f -name '*.sheet' | while read;do
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
  local _asof=$( date +'%Y%m%d' )
  mkdir -p $LOGSDIR/oper/${_asof}

  local list=${1:-"$LOGSDIR/oper/$_asof"}
  
  mkdir -p  $list
  list=$( Select 'file/folder' $( Lsf $list ) )
  Echo "### $list"
  if [ -f "$list" ];then
    act=''
    while [[ $act = '' ]];do
      act=$( Select 'action' 'cat' 'rm' 'ls -l' 'telnet' 'noop' )
      if [[ "$act" = 'telnet' ]];then
        ( /bin/mintty -t "${list##*/}"  telnet.pl $list  )&
        act=''
      fi
    done
    if [[ $act = 'noop' ]];then
      mv $list "${list%%_*}_noop.stxt"
      echo "no operation" > "${list%%_*}_noop.stxt"
    else
      eval $act '$list'
    fi
  fi
}

Macro () {
  local macro=$1
  shift
  #
  (
    prms=( "${@:-}" )
    . $APPLDIR/macro/${macro}.macro 
  )
}

Lab () {
  typeset msg="${1:-}"
  
  LNO=$(( $LNO + 1 ))
  if (( $bgn <= $LNO )) && (( $LNO <= $end ));then
    Echo "Label $LNO"
    Echo "$msg"
    return 0
  else
    Echo "Skip Label $LNO"
    return 1
  fi
}

Task () {
  local task=${1:-$( Ask -r "Task: $_target" "$_target" || Select 'task' $( Lsf *.task ) )}
  cat $task
  
  typeset -i bgn=$( Input 'Begin task' '1')
  typeset -i end=$( Input 'End   task' '99')
  
  Echo "Task: $task"
  ( 
    desc="$( basename $task .task )"
    . $task
  )
}
