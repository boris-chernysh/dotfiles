export EDITOR="vim"
export PAGER="less"
export ZSH="$HOME/.oh-my-zsh"

bindkey "^R" history-incremental-search-backward

if [[ -d ~/scripts ]]; then
	PATH+=":$HOME/scripts"
	for dir in ~/scripts/**; do
		[[ ! -d $dir ]] && continue
		PATH+=":$dir"
	done
fi

if [[ -f .oh-my-zsh/themes/bobbynotrussell.zsh-theme ]]; then
	ZSH_THEME="bobbynotrussell"
else
	ZSH_THEME="robbyrussell"
fi

if [[ -d $ZSH ]]; then
	plugins=(git bundler osx mercurial node jump brew brew-cask \
		vi-mode vim-interaction nvm npm)

	source $ZSH/oh-my-zsh.sh
fi

if [[ $OSTYPE = darwin* ]]; then
	export NVM_DIR=~/.nvm
	source /usr/local/opt/nvm/nvm.sh

	export PATH="/usr/local/sbin:/opt/local/bin:/usr/local/bin:/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH"
	export MANPATH="$MANPATH:/opt/local/share/man"
	export INFOPATH="$INFOPATH:/opt/local/share/info"

	alias chrome="open -a \"Google Chrome\""
	alias -s {html,svg,pdf}="open -a \"google Chrome\""

	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ ! $OSTYPE = linux-android ]]; then
	export PATH="$HOME/.linuxbrew/sbin:$HOME/.linuxbrew/bin:$PATH"
	export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
	export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
	export NVM_DIR="$HOME/.nvm"

	export XDG_DATA_DIRS="/home/boris/.linuxbrew/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"
	source "$HOME/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	source "$HOME/.linuxbrew/opt/nvm/nvm.sh"
fi
