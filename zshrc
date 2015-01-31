## auto comp
export PATH="$PATH:/usr/local/sbin"
export TERM=xterm-256color
#LANG="ru_RU.UTF-8"  
#LC_COLLATE="ru_RU.UTF-8"  
#LC_CTYPE="ru_RU.UTF-8"  
#LC_MESSAGES="ru_RU.UTF-8"  
#LC_MONETARY="ru_RU.UTF-8"  
#LC_NUMERIC="ru_RU.UTF-8"  
#LC_TIME="ru_RU.UTF-8"  
#LC_ALL="ru_RU.UTF-8"  

autoload -U compinit
compinit
 
## prompts
if [[ $EUID == 0 ]] 
then
	PROMPT=$'%{\e[1;34m%}%n %{\e[1;34m%}%~ %{\e[1;34m%}#%{\e[0m%} ' # user dir % %{\e[1;34m%}%n
else
	PROMPT=$'%{\e[1;32m%}→ %{\e[1;36m%}%~ %{\e[0m%}' # root dir #
fi
RPROMPT=$'%{\e[1;36m%}%T%{\e[0m%}' # right prompt with time 

export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"'
## vi bindings
bindkey -v

alias ls='ls -FG'
alias l='ls -p'
alias la='ls -a'
alias ll='ls -l' 
alias libreoffice='/Applications/LibreOffice.app/Contents/MacOS/soffice'
