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
#		s/^\t+//;
		# 行の継続
		s/^([^\t].+)$/$1  /;
		s/[ 　\t]*_  $/ /;

		# code-block処理
		s/^#!sql/~~~~sql/;
		s/^#!bash/~~~~bash/;
		s/^#!sh/~~~~bash/;
		s/^#!/~~~~/;
#		s/^#/\t#/;
#		s/^\$[ 　]/\t/;
#		s/^SQL\>[ 　]/\t/;


		# リスト処理
		s/^\t+\. /#. /;
#		s|\t(.+)$|<pre><code>$1</code></pre>|;

		# 表
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
