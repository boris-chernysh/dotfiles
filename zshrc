export EDITOR="vim"
export PAGER="less"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/dotfiles/zsh_custom"
ZSH_THEME="robbyrusselext"

bindkey "^R" history-incremental-search-backward

if [[ -d "$HOME/scripts" ]]; then
	PATH+=":$HOME/scripts"
	for dir in ~/scripts/**; do
		[[ ! -d $dir ]] && continue
		PATH+=":$dir"
	done
fi

if [[ -d $ZSH ]]; then
	plugins=(git bundler osx mercurial node jump brew brew-cask \
		vi-mode vim-interaction nvm npm)

	source $ZSH/oh-my-zsh.sh
fi

if [[ $OSTYPE = darwin* ]]; then
	alias chrome="open -a \"Google Chrome\""
	alias -s {html,svg,pdf}="open -a \"Google Chrome\""

	export PATH="/usr/local/sbin:/opt/local/bin:/usr/local/bin:/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH"
	export MANPATH="$MANPATH:/opt/local/share/man"
	export INFOPATH="$INFOPATH:/opt/local/share/info"

	export NVM_DIR="$HOME/.nvm"
	# source /usr/local/opt/nvm/nvm.sh
	NVM_INIT_SCRIPT="/usr/local/opt/nvm/nvm.sh"

	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ $OSTYPE = linux-* && ! $OSTYPE = linux-android ]]; then
	export PATH="$HOME/.linuxbrew/sbin:$HOME/.linuxbrew/bin:$PATH"
	export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
	export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

	export XDG_DATA_DIRS="/home/boris/.linuxbrew/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"
	export NVM_DIR="$HOME/.nvm"
	# source "$HOME/.linuxbrew/opt/nvm/nvm.sh"
	NVM_INIT_SCRIPT="$HOME/.linuxbrew/opt/nvm/nvm.sh"

	source "$HOME/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# init nvm, node and npm on first user call
if [[ ! $(declare -f  nvm) ]]; then
	function initNvm() {
		unalias node
		unalias npm
		unalias nvm

		source $NVM_INIT_SCRIPT
	}

	function nodeWrapper() {
		initNvm
		node "$@"
	}
	alias node=nodeWrapper

	function npmWrapper() {
		initNvm
		npm "$@"
	}
	alias npm=npmWrapper

	function nvmWrapper() {
		initNvm
		nvm "$@"
	}
	alias nvm=nvmWrapper
fi
