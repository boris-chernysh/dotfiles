export PAGER="less"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/dotfiles/zsh_custom"
ZSH_THEME="BORIS"
export NVM_DIR="$HOME/.nvm"
# export NVM_LAZY_LOAD=true
export MYVIMRC="~/dotfiles/vimrc"
export VIMINIT="source $MYVIMRC"

bindkey "^R" history-incremental-search-backward

if [[ -d $ZSH ]]; then
	plugins=(vi-mode vim-interaction jump git mercurial node npm zsh-nvm git_helpers)

	source $ZSH/oh-my-zsh.sh
fi

if [[ -d "$HOME/.linuxbrew" ]]; then
	LINUXBREW="$HOME/.linuxbrew"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
	LINUXBREW="/home/linuxbrew/.linuxbrew"
fi

if [ -n LINUXBREW ]; then
	source "$LINUXBREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

	export PATH="$LINUXBREW/bin:$LINUXBREW/sbin:$PATH"
	export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
	export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
	export XDG_DATA_DIRS="/home/boris/.linuxbrew/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"
fi

if ! [ -x "$(command -v vim)" ] && [ -x "$(command -v nvim)" ]; then
	export EDITOR="nvim"
else
	export EDITOR="vim"
fi
