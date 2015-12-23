# paths
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# colors
export TERM=xterm-256color

# completion
autoload -U compinit promptinit
promptinit
compinit

setopt CORRECT_ALL
setopt autocd

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
        'alias'           'fg=153,bold'
        'builtin'         'fg=153'
        'function'        'fg=166'
        'command'         'fg=153'
        'precommand'      'fg=153, underline'
        'hashed-commands' 'fg=153'
        'path'            'underline'
        'globbing'        'fg=166'
)

zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

fpath=(/usr/local/share/zsh-completions $fpath)

brew_args=(info home options install uninstall search list update upgrade \
	pin unpin doctor cleanup)
compctl -k brew_args brew

# modules
autoload zmv

# prompts
PROMPT=$'%{\e[1;32m%}%m→ %{\e[1;36m%}%~ %{\e[0m%}'
RPROMPT=$'%{\e[1;36m%}%T%{\e[0m%}'

# bindings
bindkey -v
bindkey '^R' history-incremental-search-backward

#aliases
alias ls='ls -FG'
alias l='ls -p'
alias la='ls -a'
alias ll='ls -l' 
alias v='vim'
which nvim > /dev/null && alias vim="nvim"
alias c="cd .."
alias initenv="virtualenv ENV --python=python3 --no-site-packages"
nvm use v0.12.9
