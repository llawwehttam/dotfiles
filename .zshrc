# History
HISTSIZE=1000000
SAVEHIST=10000000
export HISTFILE=~/.histfile
unsetopt beep notify
setopt incappendhistory
bindkey -v
zstyle :compinstall filename '/home/llawwehttam/.zshrc'
autoload -Uz compinit
compinit

# Prompt
PROMPT="%B%(?..[%?] )%b%n@%U%m%u> "
RPROMPT="%F{green}%~%f"

#Exports - Move to zprofile
export EDITOR="vim"
export TERM="xterm-256color"
export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
export BROWSER="chromium"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac

#FIXES
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

# For Libreoffice
export SAL_USE_VCLPLUGIN=gtk

###
### Aliases
###

# GENERAL

alias sudo='sudo '
alias cls='clear'
alias home='cd'
alias ll='ls -al'
alias perms='chmod'
alias gui='startx &> .xlog & vlock'
alias iotop='sudo iotop'
alias getflash='get_flash_videos'
alias open='xdg-open'
alias stats='inxi -v4 -c6 OR inxi -bDc 6'
alias irc='weechat'
alias rss='newsbeuter'
alias cmus='ncmpcpp'
alias rtfn='~/.scripts/archnews.rb'
alias share='curl -F "sprunge=<-" http://sprunge.us | xclip'
alias tv='~/.scripts/tv.sh'
alias archey='watch -cn 60 archey3'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias vol='~/.scripts/pulsevol.sh'
alias clock='tty-clock -csC 3'
alias hc='herbstclient'

# Vagrant - Puhpet defaults
alias ls='ls -F --color=always'
alias dir='dir -F --color=always'
alias ll='ls -l' 
alias cp='cp -iv'
alias rm='rm -i' 
alias mv='mv -iv'
alias grep='grep --color=auto -in'
alias ..='cd ..' 

# Todo Script
alias t="~/.todo.sh"

# Amazon Music
alias amazonmusic='env WINEPREFIX="/home/llawwehttam/.wineamazon" wine "C:/users/llawwehttam/Local Settings/Application Data/Amazon Music/Amazon Music.exe"'

# GAMES

# Minecraft - Now using binary
#alias minecraft='wmname LG3D && java -jar -Xms4096M -Xmx4096M $HOME/.minecraft/Minecraft.jar'
#alias minecraftmagic='wmname LG3D && java -jar -Xms4096M -Xmx4096M $HOME/.minecraft/MagicLauncher_1.2.5.jar'
#alias minecraftdigex='wmname LG3D && java -jar -Xms4096M -Xmx4096M $HOME/.minecraft/mclauncher.jar'

# Dwarf Fortress
alias dwarf='cd ~/.dwarf-fortress/df_linux_0.40.13/ && ./dfhack'
alias dwarffix='echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope'

# Eve Online
alias eve='WINEDLLOVERRIDES="*msvcrt,*msvcr100,*msvcr90,*msvcr80=b,n" wine "C:\Program Files (x86)\CCP\EVE\bin\ExeFile.exe"'
alias eve-launcher='WINEDLLOVERRIDES="*msvcr100,*msvcr90,*msvcr80=n,b" wine "C:\Program Files (x86)\CCP\EVE\eve.exe"'

# VPN
alias proxpn='sudo openvpn --config .openvpn/proxpn.ovpn'

###
### FUNCTIONS
###

# Function for watching twitch.tv livestreams
function twitch() {
  livestreamer twitch.tv/$1 best
}

# Implement an insults script for typos
function command_not_found_handler() {/home/llawwehttam/.scripts/insults.pl;}

# Extract without having to remember commands
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xvjf $1    ;;
			*.tar.gz)    tar xvzf $1    ;;
			*.bz2)       bunzip2 $1     ;;
			*.rar)       unrar e $1     ;;
			*.gz)        gunzip $1      ;;
			*.tar)       tar xvf $1     ;;
			*.tbz2)      tar xvjf $1    ;;
			*.tgz)       tar xvzf $1    ;;
			*.zip)       unzip $1       ;;
			*.Z)         uncompress $1  ;;
			*.7z)        7z x $1        ;;
			*)           echo "don't know how to extract "$1"..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}


# Setup rvm for ruby
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting


#Coloured Manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Marks (for quick filesystem navigation)
export MARKPATH=$HOME/.marks
function jump {
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark {
    rm -i $MARKPATH/$1
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

# Named Directories (Basically persistant marks for longer projects etc..., marks will be used mainly within projects)
typeset -A NAMED_DIRS

NAMED_DIRS=(
#nothing right now
)

for key in ${(k)NAMED_DIRS}
do
    if [[ -d ${NAMED_DIRS[$key]} ]]; then
        export $key=${NAMED_DIRS[$key]}
    else
        unset "NAMED_DIRS[$key]"
    fi
done

# List keys
function lsn () {
    for key in ${(k)NAMED_DIRS}
    do
        printf "%-10s %s\n" $key  ${NAMED_DIRS[$key]}
    done
}

# GPG set up properly this time
if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
fi

# Auto-open some programs with specific window names.
~/.scripts/zshrun.sh
