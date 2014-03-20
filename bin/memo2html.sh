#!/bin/sh -u

typeset fn=${1:-_memo}

#

nkf32 -Sw $fn.md |
pandoc -f markdown -t html5 -c memo.css -s --toc --section-divs -B memo.header -A memo.footer -o $fn.html

#pandoc -f markdown -t html5 -c memo.css -s --toc -o $fn.html <<-MARKDOWN
#	
#	
#	<section>
#	
#		$( nkf32 -Sw $fn.md )
#	
#	</section>
#	
#	
#MARKDOWN

exit
