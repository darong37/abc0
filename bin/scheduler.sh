#!/bin/sh -u
readonly APPLDIR=$( cd `dirname $0`;pwd )         # スクリプト格納場所
readonly APPLNAM=`basename $0 .sh`                # スクリプト名
readonly BASEDIR=$( dirname $APPLDIR )            # Base
readonly CONFDIR=$BASEDIR/conf                    # 設定用ディレクトリ
. $APPLDIR/appl

### コマンドライン
readonly JOBGRP=$1                                # ジョブグループ名
shift

### ファイル設定
readonly SCHTEMP=$BASEDIR/temp/${APPLNAM}.$$     # リターンステータスファイル
readonly RTNFILE=$BASEDIR/temp/${JOBGRP}.rtn     # リターンステータスファイル
readonly LOGFILE=$BASEDIR/logs/${JOBGRP}.log     # ログファイル

### 変数
typeset step
typeset shellName
typeset prms

##
cd $APPLDIR
(
	typeset -i rtn=0
	egrep "^$JOBGRP" $CONFDIR/schedule |
	perl  -ple "s/^$JOBGRP\s+//"       |
	sort > $SCHTEMP
	
	:> $RTNFILE
	while read step shellName prms;do
		if (( $rtn != 0 ));then
			Error "Step-$step.  Shell:'$shellName' SKIP"
			continue
		fi
		
		if [[ -r $shellName ]];then
			: > $BASEDIR/temp/$shellName.tmp

			Info  "Step-$step.  Shell:'$shellName' Start"
			./$shellName ${prms:-}
			rtn=$?

			if (( $rtn == 0 ));then
				rm $BASEDIR/temp/$shellName.tmp
			else
				Error "Step-$step.  Shell:'$shellName' ERROR Occured"
			fi
		else
			rtn=999
			Error "Step-$step.  Shell:'$shellName' can not read"
		fi
		echo "$step $shellName $rtn" >> $RTNFILE
	done < $SCHTEMP
	
	rm $SCHTEMP
	
	exit
) 2>&1 | ( #logging.pl $LOGFILE
	while read;do
		if [[ "$REPLY" != *'set +x' ]];then
			echo "$(date '+%Y/%m/%d %H:%M:%S') $REPLY"
		fi
	done
) | tee $LOGFILE
#
echo
typeset -i RTN=-999
while read step shellName RTN;do
	if (( $RTN == 0 ));then
		echo "Step-$step. $shellName: OK"
	else
		echo "Step-$step. $shellName: NG return $RTN"
		echo
		echo "# cat $LOGFILE"
		exit $RTN
	fi
done < $RTNFILE

rm -f $RTNFILE

echo
echo "# cat $LOGFILE"

