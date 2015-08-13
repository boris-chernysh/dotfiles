
# Syntx highlighting enable
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=cxbxexgxexfxfxfxfxfxcx
export PS1='\[\e[0;34m\]\A \e[1;34m\]\u: \e[0;34m\]\w \n\e[0;37m\]\$\[\e[0m\] '

#export PS1="\[\e[1;34m\]\u: \e[0;32m\]\w\n\e[1;34m\]\$ \e[s\]\[\e[1;34m\]\e[1;\$((COLUMNS-4))f\]\$(date +%H:%M)\[\e[u\]\[\e[0m\]" 

alias l="ls -p"
alias ll="ls -l"
alias la="ls -a"
alias tmux="TERM=screen-256color-bce tmux"

set -o vi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
