#!/bin/sh -u

typeset fn=${1:-_memo}

#

nkf32 -Sw $fn.md |
pandoc -f markdown -t html5 -c memo.css -s --toc -o $fn.html

exit
