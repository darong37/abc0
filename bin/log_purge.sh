#!/bin/sh -u
readonly APPLDIR=$( cd `dirname $0`;pwd )     # スクリプト格納場所
readonly APPLNAM=`basename $0 .sh`            # スクリプト名
. $APPLDIR/appl

### コマンドライン
readonly LSTFILE=${1:-$APPLDIR/$APPLNAM.lst}  # リストファイル

### 変数
typeset targetPath                            # リストファイル内の対象フォルダ(targetPath欄)
typeset fileName                              # リストファイル内の対象ファイル名(fileName欄)
typeset keepDays                              # リストファイル内の保存期間(keepDays欄)

### Main
ls $LSTFILE 1> /dev/null                      # ファイル存在チェック

###
### リストファイルを読込む
###
typeset -i cnt=0                              # リストファイルの行カウンタ
while read targetPath	fileName	keepDays;do
    cnt=cnt+1
	if [[ $targetPath = '#'* ]];then continue;fi
	if [[ $targetPath = ''   ]];then continue;fi

	Info ""
	Info "Line $cnt in $( basename $LSTFILE)"
	Info " 1. targetPath : $targetPath"
	Info " 2. fileName   : $fileName"
	Info " 3. keepDays   : $keepDays"
	
	### リストファイルのパラメータをチェックする
	if ! expr "$keepDays" + 1  1> /dev/null ;then        # keepDaysが数値かどうかのチェック
		ERROR "Invaild Parameter 'keepDays' in $( basename $LSTFILE)"
		exit 1
	fi

	TraceON         ### Log Trace開始
		cd   $targetPath
		find ./ -type f -name "$fileName" -mtime "+${keepDays}" > $TMPFILE
	TraceOFF        ### Log Trace終了
	

	### 対象ファイルを消去する
	typeset target
	while read target;do
		TraceON         ### Log Trace開始
			RM $target
		TraceOFF        ### Log Trace終了
	done < $TMPFILE
done < $LSTFILE

Succ "Normal End"
exit
