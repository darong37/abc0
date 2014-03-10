#!/bin/sh -u
#
#	'□' -> '#'
#	'■' -> '##'
#

typeset fn=${1:-_memo}
typeset -i op=${2:-0}

#
if (( $op < 1 ));then
	echo '' >  $fn.md
	echo '' >> $fn.md

	{	cat <<-'PERL'
	#		s/^\t+//;

			s/^([^\t].+)$/$1  /;
			s/[ 　\t]*_  $/ /;

			
			s/^#!sql/~~~~sql/;
			s/^#!bash/~~~~bash/;
			s/^#!sh/~~~~bash/;
			s/^#!/~~~~/;
			s/^#/\t#/;

			s/^\t+\. /#. /;
	#		s|\t(.+)$|<pre><code>$1</code></pre>|;

			s/^\$[ 　]/\t/;
			s/^SQL\>[ 　]/\t/;
			
			s/□[ 　]*/# /;
			s/■[ 　]*/## /;
			s/●[ 　]*/### /;
			s/・[ 　]*/###### /;
			
			__END__
		PERL
		cat $fn.txt
	} | perl -pl >> $fn.md
fi

nkf32 -Sw $fn.md |
pandoc -f markdown -t html5 -c _memo.css -s --toc -o $fn.html

exit
