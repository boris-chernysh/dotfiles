export PAGER="less"

bindkey "^R" history-incremental-search-backward

# nvm
export NVM_DIR="$HOME/.nvm"

# vim
export MYVIMRC="$HOME/dotfiles/vimrc"
export VIMINIT="source $MYVIMRC"
export EDITOR="vim"

# oh-my-zsh
export ZSH="$HOME/dotfiles/ohmyzsh"
export ZSH_CUSTOM="$HOME/dotfiles/zsh_custom"
ZSH_THEME="BORIS"

if [[ -d $ZSH ]]; then
	plugins=(vi-mode vim-interaction jump git node npm zsh-nvm git_helpers zsh-syntax-highlighting yarn kubectl)

	source $ZSH/oh-my-zsh.sh
fi
