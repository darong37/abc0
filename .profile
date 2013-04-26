
export PS1='
#
# \t $$ ${PWD##~/}
#
\$ '

#export PATH=$PATH:~/bin:~/apps/ruby/current/bin:~/apps/msysgit/bin
export FPATH=$HOME/func

export LANG=ja_JP.SJIS
export TZ=JST-9
export OUTPUT_CHARSET=sjis
export LC_MESSAGES=C

alias ls='ls --show-control-chars'
alias ld='ls -l | grep ^d'
alias lf='ls -l | grep -v ^d'

alias lc='ls --color=auto --show-control-chars'

alias Df="/c/Users/JKK0544/apps/df/df141/DF.exe"
alias Sakura="/c/Users/JKK0544/AppData/Roaming/sakura/sakura.exe"

alias Edlog='Sakura $MINLOG'
alias Exp='/c/Windows/explorer.exe root,`pwd`'

FPATH_B=$HOME/func
# Function Auto Load
for _func in $( ls -1 $FPATH_B 2>&- );do
	_func=$( basename $_func )
	( . $FPATH_B/${_func} ) || {
		echo "Error while loading function: $_func in $FPATH_B"
		exit 97
	}
	. $FPATH_B/$_func
done
unset _func

cd $( f_convpath "${CALLDIR:-.}" )
#
# For Ruby
#
#alias irb='console irb.bat'
#alias pry='console pry.bat'
#alias gem='console gem.bat'
#alias git='console git'
