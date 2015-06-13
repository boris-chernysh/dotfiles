## auto comp
export PATH="$PATH:/usr/local/sbin:/opt/local/bin/"
export MANPATH="$MANPATH:/opt/local/share/man"
export INFOPATH="$INFOPATH:/opt/local/share/info"
export TERM=xterm-256color

autoload -U compinit promptinit
compinit
promptinit

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

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# prompts
if [[ $EUID == 0 ]] 
then
	PROMPT=$'%{\e[1;34m%}%n %{\e[1;34m%}%~ %{\e[1;34m%}#%{\e[0m%} ' # user dir % %{\e[1;34m%}%n
else
	PROMPT=$'%{\e[1;32m%}→ %{\e[1;36m%}%~ %{\e[0m%}' # root dir #
fi
RPROMPT=$'%{\e[1;36m%}%T%{\e[0m%}' # right prompt with time 

export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"'
# vi bindings
bindkey -v

alias ls='ls -FG'
alias l='ls -p'
alias la='ls -a'
alias ll='ls -l' 
alias libreoffice='/Applications/LibreOffice.app/Contents/MacOS/soffice'
alias -s {html,svg,pdf}="open -a 'google Chrome'"

fpath=(/usr/local/share/zsh-completions $fpath)
