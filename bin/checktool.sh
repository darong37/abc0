#!/bin/sh -u
#
# usage:
#	tools/checktool.sh Summary
#
APPLDIR=$( cd $(dirname $0) && pwd )
BASEDIR=${APPLDIR%%/tools}     # ./ , ./toolsどちらでも起動可,通常はtools以下

cd $BASEDIR
if [ ! -e $APPLDIR/_filter.pl ];then
	cat > $APPLDIR/_filter.pl <<-'_EOF_'
		#!/usr/bin/perl -nl
		use strict;
		use warnings;

		# ファイルパーミッションに関する定数をインポート
		use Fcntl ':mode';

		s/#.+$//;        # コメントを削除
		s/\s+$//;        # 後ろのスペース等を削除
		s/^.+\s+//;      # 最後のスペース以降をファイル名として残す
		s/\*$//;         # 最後の'*'を除去

		next if /^\s*$/;          # スペース、空行をスキップ
		next if /^_recycle$/;     # トップの_recycleをスキップ
		next if /^_recycle\//;    # トップの_recycle内をスキップ
		next if /\/_recycle$/;    # _recycleをスキップ
		next if /\/_recycle\//;   # _recycle内をスキップ

		next if /^\.\/prognosis/; # prognosis以下をスキップ
		

		# stat関数の戻り値の3つ目の要素がファイル
		# パーミッションの情報
		my @sts = stat;

		# 所有者ユーザID(数値)からユーザ名を取得する
		my $uname = getpwuid $sts[4];

		# 所有グループID(数値)からグループ名を取得する
		my $gname = getgrgid $sts[5];


		# Sizeを取得する
		my $siz = $sts[7];


		# cksum
		my $chk = '';

		if ( S_ISREG($sts[2]) ) {
		  #localtimeで現地時間に変換
		  my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($sts[9]);

		  $chk = `cksum $_` ;
		  chomp $chk;
		  $chk =~ s/ .+$//;

		  # パーミッションをS_IMODE関数で数値に変換
		  printf "%-50s\t#\t%03o \t%-8s\t%-8s\t%04d/%02d/%02d %02d:%02d:%02d \t%8d\t%s\n"
		    , $_, S_IMODE($sts[2]), $uname, $gname, $year+1900, $mon+1, $mday, $hour, $min, $sec, $siz, $chk;
		} else {
		  $_ = "$_/" unless /\/$/;

		  # パーミッションをS_IMODE関数で数値に変換
		  printf "%-50s\t#\t%03o \t%-8s\t%s\n"
		    , $_, S_IMODE($sts[2]), $uname, $gname;
		};
	_EOF_
	chmod 755 $APPLDIR/_filter.pl
fi

if [ ! -e $APPLDIR/_diff.pl ];then
	cat > $APPLDIR/_diff.pl <<-'_EOF_'
		#!/usr/bin/perl
		use strict;
		use warnings;

		my ( $src,$upd ) = @ARGV;

		open SRC,"<",$src or die "not found '$src'";
		open UPD,"<",$upd or die "not found '$upd'";

		my %h;
		my ( $oldver,$updver ) = ( 'n/a','n/a' );
		while(<SRC>){
		  chomp;
		  next if /^\s*$/;
		  
		  s/^# Version : /Version # /;
		  s/\s+/ /g;
		  my ( $key,$val ) = split / # /;
		  if ( $key eq 'Version' ){
		    $oldver = $val;
		  } else {
		    # keyの先頭フォルダの'.'以下は無視する
		    # $key =~ s{^([^/.\s]+)\.[^/\s]+}{$1};
		    
		    $h{$key} = $val;
		  }
		}
		close SRC;

		while(<UPD>){
		  chomp;
		  next if /^\s*$/;

		  s/^# Version : /Version # /;
		  s/\s+/ /g;
		  my ( $key,$val ) = split / # /;
		  if ( $key eq 'Version' ){
		    $updver = $val;
		  } else {
		    # keyの先頭フォルダの'.'以下は無視する
		    # $key =~ s{^([^/.\s]+)\.[^/\s]+}{$1};
		    
		    if ( exists $h{$key} ) {
		      if ( $h{$key} eq $val ){
		        delete $h{$key};
		      } else {
		        my @ele1 = split /\s+/ ,$h{$key};
		        my @ele2 = split /\s+/ ,$val;
		        my $eln = $#ele1;
		        if ( $eln < 6 ) {
		            # permition が異なる
		            $h{$key} = "chg perm";
		        } else {
		          if ( $ele1[6] ne $ele2[6] ) {
		            # cksum が異なる
		            if ( "$ele1[0] $ele1[1] $ele1[2]" ne "$ele2[0] $ele2[1] $ele2[2]" ){
		              # さらにpermission が異なる
		              $h{$key} = "mod+perm";
		            } else {
		              $h{$key} = "modified";
		            }
		          } else {
		            if ( "$ele1[0] $ele1[1] $ele1[2]" ne "$ele2[0] $ele2[1] $ele2[2]" ){
		              # permission が異なる
		              $h{$key} = "chg perm";
		            } else {
		              $h{$key} = "chg date";
		            }
		          }
		        }
		      }
		    } else {
		      $h{$key} = "new file";
		    }
		  }
		}
		close UPD;
		#
		# Results
		#
		my $dcnt=0;
		print "\n";
		if ( $oldver eq $updver ){
		  print "    Version      $updver\n\n";
		} else {
		  print "    Version      $oldver  ->  $updver\n\n";
		}
		for my $key ( sort keys %h){
		  $dcnt++;
		  my $val = $h{$key};
		  $h{$key} = "deleted " if $val !~ /new file|modified|mod\+perm|chg perm|chg date/;
		  
		  printf "    %s:    %s\n",$h{$key},$key;
		}

		if ( $dcnt == 0 ){
		  print "\n";
		  print "    identified\n";
		  exit
		} else {
		  print "\n";
		  print "    different\n";
		  exit 1
		} 
	_EOF_
	chmod 755 $APPLDIR/_diff.pl
fi

if [ ! -e $APPLDIR/_target.hosts ];then
	cat > $APPLDIR/_target.hosts <<-'_EOF_'
		mecerpa0111
		mecerpd0111
		mecerp2a0111
		mecerp2d0111
	_EOF_
fi

###
### Common Function
###
Ver () {
  # Folder | CheckList
  local _TARGET=${1:-scripts}

  if [ -e "$_TARGET/.checklist" ];then
    egrep "^# Version : "  $_TARGET/.checklist | perl -ple 's/^.+ : //'
  elif [ -f "$_TARGET" ];then
    egrep "^# Version : "  $_TARGET | perl -ple 's/^.+ : //'
  else
    date +%Y%m%d
  fi
}

Check () {
  # Folder | @Folder | CheckList | @CheckList
  local _TARGET=${1:-scripts}
# local _VER=${2:-$( date +%Y%m%d )}
  local _VER=${2:-"$(uname -n):$_TARGET"}
  
  if [ -d "$_TARGET" ];then
    # フォルダ
    echo  "# Version : $_VER"
    ( cd ${_TARGET}; find . ! -name .checklist | perl -nl $APPLDIR/_filter.pl )
  elif [ -f "${_TARGET}" ];then
    # チェックリスト
    cat ${_TARGET}
  elif [[ "$_TARGET" = @* ]];then
    if [ -f "${_TARGET#@}/.checklist" ];then
      # チェックリスト -> フォルダ 
      _TARGET="${_TARGET#@}"
#     egrep "^# Version : "  ${_TARGET}/.checklist
      echo  "# Version : $_VER"
      ( cd  ${_TARGET}; cat .checklist           | perl -nl $APPLDIR/_filter.pl )
    elif [ -f "${_TARGET#@}" ];then
      # チェックリスト -> フォルダ 
      _TARGET="${_TARGET#@}"
#     egrep "^# Version : "  ${_TARGET}
      echo  "# Version : $_VER"
      ( cd  ${_TARGET%/*}; cat ${_TARGET##*/}    | perl -nl $APPLDIR/_filter.pl )
    else
      echo  "# Version : Invalid ($_VER)"
    fi
  else
    echo  "# Version : Invalid ($_VER)"
  fi
}

Crc () {
  # Folder | @Folder | CheckList | @CheckList
  local _TARGET=${1:-scripts}
  
  if [ -d "$_TARGET" ];then
    :
  elif [ -f "${_TARGET}" ];then
    :
  elif [[ "$_TARGET" = @* ]];then
    if   [ -f "${_TARGET#@}/.checklist" ];then
      :
    elif [ -f "${_TARGET#@}" ];then
      :
    else
      echo  "0"
      return
    fi
  else
    echo  "0"
    return
  fi
  Check ${_TARGET} | egrep -v '^# V' | cksum | perl -ple 's/ .+$//'
}

Changes () {
  # Folder
  local _TARGET=${1:-scripts}
  
  src=$( Crc $_TARGET/.checklist )
  chg=$( Crc "@$_TARGET" )
  all=$( Crc "$_TARGET" )

  echo "$src $chg $all"
}

f_stat () {
  # Folder
  local _TARGET=${1:-scripts}
  
  ### Title
  c_fmt="%-14s  %-30s  %-22s  %-6s  %-6s  %-9s\n"
  if [[ $_TARGET = '-t' ]];then
    printf "$c_fmt" "ホスト"         "フォルダ"                       "バージョン(cksum)"     "変更"   "不定"   "状態"      >&2
    printf "$c_fmt" "--------------" "------------------------------" "---------------------" "------" "------" "---------" >&2
    return
  fi
  
  ### Results
  _loca=$PWD/$_TARGET
  if (( ${#_loca} > 30 ));then
    _loca=${_loca##*/}
  fi
  local _cver=$( Ver $_TARGET )

  local _csum=0
  local _chgs='?'
  local _ireg='?'
  local _stat='not yet'
  
  set -A array $( Changes $_TARGET )
  if (( ${array[0]} == 0 ));then
    _csum=${array[2]}
    _chgs='?'
    _ireg='?'
    _stat='not yet'
  else
    _csum=${array[0]}
    if (( ${array[0]} == ${array[1]} ));then
      _chgs='no'
      if (( ${array[0]} == ${array[2]} ));then
        _ireg='no'
        _stat='identify'
      else
        _ireg='exists'
        _stat='no change'
      fi
    else
      _chgs='exists'
      _ireg='-'
      _stat='different'
    fi
  fi
  printf "$c_fmt" "$(uname -n)"  "$_loca"  "$_cver ($_csum)"  "$_chgs" "$_ireg" "$_stat"
}

Status () {
  # ( -t )
  # Folders...
  if [[ ${1:-} = '-t' ]];then
    f_stat -t
    shift
  fi
  for tgt in "${@:-scripts}";do
    if [ -d $tgt ];then
      f_stat $tgt
    fi
  done
}

Diff () {
  # ( -k )
  # Folder | @Folder | CheckList | @CheckList
  if [[ ${1:-} = '-k' ]];then
    keep=on
    shift
  else
    keep=off
  fi
  local cl1=${1:-scripts/.checklist}
  local cl2=${2:-"@$cl1"}
  
  echo "Source : $cl1" >&2
  echo "Update : $cl2" >&2
  
  Check "$cl1" > ./checklist.diff-1
  Check "$cl2" > ./checklist.diff-2
  
  $APPLDIR/_diff.pl ./checklist.diff-1 ./checklist.diff-2
  if [[ $keep = 'off' ]];then
    rm ./checklist.diff-1
    rm ./checklist.diff-2
  fi
}

Create () {
  # Version
  # Folder
  local _VER=${1:-$( date +%Y%m%d )}
  local _TARGET=${2:-scripts}

  [ -e $_TARGET/.checklist ] && mv $_TARGET/.checklist ./.checklist
  Check "$_TARGET" "$_VER" > $_TARGET/.checklist
}

Remote () {
  # Remote Command
  # Hosts
  local _RMCMD="${1:-r_status}"
  local _HOSTS=${2:-$( cat $APPLDIR/_target.hosts )}

  for _HOST in $_HOSTS ;do
    rcp   $APPLDIR/checktool.sh root@${_HOST}:/u00/unyo
    if (( $? != 0 ));then
      echo "! ${_HOST} でのチェックが失敗しました"
    fi
    remsh ${_HOST} "/bin/sh /u00/unyo/checktool.sh $_RMCMD"
    remsh ${_HOST} 'rm /u00/unyo/checktool.sh'
  done
}

### Local
Summary (){
  # Folder
  local _TARGET=${1:-scripts}

  echo "## 各サーバのインストール状態及び整合性チェック"
  echo
  
  Status -t $_TARGET
  echo
  
  # remote
  Remote "r_status $_TARGET"
}

Detail (){
  # Folder
  local _TARGET=${1:-scripts}

  Status -t $_TARGET
  echo

  sleep 1
  Diff   $_TARGET/.checklist  $_TARGET
}

Dtest (){
  # Host
  local _host=${1:-mecerpd0111}
  typeset -u _HOST="$_host"

  /usr/sbin/rdist -v -f $BASEDIR/tools/distfile_each.txt $_HOST

  Remote 'r_check'  "$_host"  > ./.checklist
  echo
  Status -t
  echo
  Diff   ./.checklist  scripts/.checklist
  echo
  echo "# /usr/sbin/rdist -v -f tools/distfile_each.txt $_HOST"
  echo "# /usr/sbin/rdist -f tools/distfile_each.txt $_HOST"
}

### Else
f_nocmd () {
  echo
  echo "!!ERROR"
  echo "!"
  echo "! サブコマンドが無効です: $1"
  echo "!"
  echo "!!ERROR"
}

f_func () {
  local _FUNC
  {
    echo
    echo '#? ファンクションの番号を選択してください'
    PS3='>> '
    select _FUNC in $( typeset -f |grep function |perl -ple 's/function //' ) ;do
      echo
      break
    done
  } >&2
  echo $_FUNC
}

Trace () {
  local _FUNC=${1:-$( f_func )}

  local tron=$( typeset -ft |grep "$_FUNC" )
  if [[ "$tron" = "" ]];then
    typeset -ft $_FUNC
  else
    typeset +ft $_FUNC
  fi
}

###
### Main
###
export PS4='        +$LINENO	'
cd $BASEDIR

_SUBCMD=${1:-repl}
(( $# > 0 )) && shift

if  tty -s;then
  if [[ $_SUBCMD = 'repl' ]];then
    typeset -i cnt=0
    while(( cnt < 5 ));do
      _prompt=${PWD#$BASEDIR/}
      _prompt=${_prompt#$BASEDIR}
#     read SUB?"$_prompt> "
      echo -n "$_prompt> "
      read SUB
      if [[ $SUB = '' ]];then
        cnt=cnt+1
      else
        cnt=0
        eval "$SUB"
        echo "\n--> $?"
      fi
    done
  else
    # Local
    echo "#: $_SUBCMD  ${@:-}"
    case $_SUBCMD in
      summary)  Summary   "${@:-}" ;;
      detail)   Detail    "${@:-}" ;;
      * )       f_nocmd   $_SUBCMD ;;
    esac
  fi
else
  # Remote
  case $_SUBCMD in
    r_check)  Check    "${@:-}"  ;;
    r_status) Status   "${@:-}"  ;;
    r_detail) Detail   "${@:-}"  ;;
    * )       f_nocmd  $_SUBCMD  ;;
  esac
fi

###
[ -e $APPLDIR/_filter.pl    ] && mv $APPLDIR/_filter.pl $APPLDIR/filter.pl
[ -e $APPLDIR/_diff.pl      ] && mv $APPLDIR/_diff.pl   $APPLDIR/diff.pl
[ -e $APPLDIR/_target.hosts ] && rm $APPLDIR/_target.hosts
[ -e $BASEDIR/.checklist*   ] && rm $BASEDIR/.checklist*

exit
