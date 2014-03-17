#!/bin/sh -u
#
#	'□' -> '#'
#	'■' -> '##'
#

typeset fn=${1:-_memo.txt}

#
echo ''
echo ''

{	cat <<-'PERL'
		# 改行コード統一化 
		s/\r//;

		# 行の継続
		s/^([^\t].+)$/$1  /;
		s/[ 　\t]*_  $/ /;

		# code-block処理
		s/^#!sql/\n~~~~sql/;
		s/^#!bash/\n~~~~bash/;
		s/^#!sh/\n~~~~bash/;
		s/^#!/\n~~~~/;


		# リスト処理
		s/^\t+\. /#. /;

		# 表処理
		s/^\t/    /;
		s/\t/\|/g;

		# ヘッダ処理
		s/□[ 　]*/# /;
		s/■[ 　]*/## /;
		s/●[ 　]*/### /;
		s/・[ 　]*/###### /;
		
		__END__
	PERL
	cat $fn
} | perl -pl

exit
