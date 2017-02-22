export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"

bindkey '^R' history-incremental-search-backward

function nbin() {
	$(npm bin)/$@
}

plugins=(git bundler osx mercurial node jump brew brew-cask \
	vi-mode vim-interaction nvm npm)

if [[ -d ~/scripts ]]; then
	PATH+=":$HOME/scripts"
	for d in ~/scripts/**; do
		[[ ! -d $d ]] && continue
		PATH+=":$d"
	done
fi

if [[ ! `uname -m` = 'aarch64' ]] then;
	ZSH_THEME="bobbynotrussell"
else
	ZSH_THEME="robbyrussell"
fi

source $ZSH/oh-my-zsh.sh

if [[ `uname` = 'Darwin' ]]; then;
	# TODO: replace this with static paths:
	export NVM_DIR=~/.nvm
	which brew >> /dev/null && NVM_PREFIX=$(brew --prefix nvm)
	[[ -d $NVM_PREFIX ]] && source $NVM_PREFIX/nvm.sh

	export PATH="/usr/local/sbin:/opt/local/bin:/usr/local/bin:/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH"
	export MANPATH="$MANPATH:/opt/local/share/man"
	export INFOPATH="$INFOPATH:/opt/local/share/info"

	alias chrome='open -a "Google Chrome"'
	alias -s {html,svg,pdf}="open -a 'google Chrome'"

	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ ! `uname -m` = 'aarch64' ]]; then;
	export PATH="$HOME/.linuxbrew/sbin:$HOME/.linuxbrew/bin:$PATH"
	export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
	export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
	export NVM_DIR="$HOME/.nvm"
	export NVM_INIT_SCRIPT=

	export XDG_DATA_DIRS="/home/boris/.linuxbrew/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"
	source "$HOME/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	source "$HOME/.linuxbrew/opt/nvm/nvm.sh"
fi
