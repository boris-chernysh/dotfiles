export PAGER="less"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/dotfiles/zsh_custom"
ZSH_THEME="BORIS"
export NVM_DIR="$HOME/.nvm"
# export NVM_LAZY_LOAD=true

bindkey "^R" history-incremental-search-backward

if [[ -d $ZSH ]]; then
	plugins=(vi-mode vim-interaction jump git mercurial node brew npm zsh-nvm git_helpers)

	source $ZSH/oh-my-zsh.sh
fi

if [[ $OSTYPE = darwin* ]]; then
	alias chrome="open -a \"Google Chrome\""
	alias -s {html,svg,pdf}="open -a \"Google Chrome\""

	export PATH="/usr/local/sbin:/opt/local/bin:/usr/local/bin:/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH"
	export MANPATH="$MANPATH:/opt/local/share/man"
	export INFOPATH="$INFOPATH:/opt/local/share/info"

	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ $OSTYPE = linux-* && ! $OSTYPE = linux-android ]]; then
	export PATH="$HOME/.linuxbrew/sbin:$HOME/.linuxbrew/bin:$PATH"
	export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
	export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
	export XDG_DATA_DIRS="/home/boris/.linuxbrew/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"

	source "$HOME/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if ! [ -x "$(command -v vim)" ] && [ -x "$(command -v nvim)" ]; then
	export EDITOR="nvim"
else
	export EDITOR="vim"
fi
