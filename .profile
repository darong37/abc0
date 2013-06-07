#
# Function Auto Load
#
export FPATH_B=~/func

for _func in $( ls -1 $FPATH_B 2>&- );do
	_func=$( basename $_func )
	( . $FPATH_B/${_func} ) || {
		echo "Error while loading function: $_func in $FPATH_B"
		sleep 20
#		exit 97
	}
	. $FPATH_B/$_func
done
unset _func
###

export PS1='
#
# \t $$ ${PWD##~/}
#
\$ '

#
export PATH=$( AddPath /git/bin /ruby/bin /node /node/node_modules/coffee-script/bin /node/node_modules/js2coffee/bin ~/bin ~/exe )

#export LANG=ja_JP.SJIS
export LANG=ja_JP.UTF-8
export TZ=JST-9
export OUTPUT_CHARSET=sjis
export LC_MESSAGES=C

alias ls='ls --show-control-chars'
alias ll='ls -l'
alias la='ls -la --color=auto --show-control-chars'
alias lc='ls -l --color=auto --show-control-chars'
alias ld='ls -l | grep ^d'
alias lf='ls -l | grep -v ^d'

cd $( ConvPath "${DIR_CALL:-.}" )
#
# forign command
#
alias es="$( ConvPath "$DIR_APPS" )/Everything/es.exe"
alias irb='console irb.bat'
alias pry='console pry.bat'
alias gem='console gem.bat'
alias git='console git'
alias npm='console npm.cmd'
alias tree='console /c/Windows/System32/tree.com'
