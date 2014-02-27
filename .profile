#
# Function Auto Load
#
. bin/autofunc

#
export PS1='
#
# \t $$ ${PWD##~/}
#
\$ '

#
export PATH=$( AddPath -pre /usr/local/node )
export PATH=$( AddPath /usr/local/git/bin /usr/local/ruby/bin )
export PATH=$( AddPath /usr/local/node/node_modules/.bin )
export PATH=$( AddPath ~/bin ~/exe )

export LANG=ja_JP.SJIS
#export LANG=ja_JP.UTF-8
export TERM=msys
export TZ=JST-9
export OUTPUT_CHARSET=sjis
export LC_MESSAGES=C
