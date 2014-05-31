# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

test -s ~/.alias && . ~/.alias || true

export EDITOR='vim'
export PATH=$PATH:/opt/java/bin:~/bin:/home/makpoc/scripts
export GIT_PS1_SHOWDIRTYSTATE=1

if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh
fi

#export TERM='rxvt-unicode-256color'
#export TERM='screen-256color'
COLOR_RESET="\[\e[0m\]"
COLOR_NORMAL="\[\e[0;37m\]"
COLOR_ROOT="\e[1;91m"
COLOR_USER="\e[0;33m"
COLOR_HOST="\e[0;96m"
COLOR_CWD="\[\e[0;32m\]"
RED="\[\033[31;1m\]"
YELLOW="\[\033[33;1m\]"
WHITE="\[\033[37;1m\]"
SMILEY="${WHITE}:)${COLOR_NORMAL}"
FROWNY="${RED}:(${COLOR_NORMAL}"
SELECT="if [ \$? = 0 ]; then echo \"${SMILEY}\"; else echo \"${FROWNY}\"; fi"

#If you get distorted sound in skype, try adding PULSE_LATENCY_MSEC=60 to your
#env before starting skype. Something like 'export PULSE_LATENCY_MSEC=60' in .bashrc, for example.

if [[ ${EUID} == 0 ]] ; then
    sq_color=$COLOR_ROOT
else
    sq_color=$COLOR_USER
fi
PS1="$COLOR_NORMAL┌─[${root}$sq_color\u碁$COLOR_NORMAL‖$COLOR_HOST\h$COLOR_NORMAL] [$COLOR_CWD\w$COLOR_NORMAL] \$(__git_ps1 \"[$YELLOW%s$COLOR_NORMAL]\")\n└──── $RESET"

# Solarized theme for ls command. (https://github.com/seebi/dircolors-solarized)
if [ -f ~/.ls_colors ]; then
    eval `dircolors ~/.ls_colors`
fi

# Solarized theme for grep (https://github.com/cleversimon/dotfiles/blob/master/bash/colours.bash)
if [ -f ~/.grep_colors ]; then
    . ~/.grep_colors
fi

archey

# Add color to man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
}

# Make pacman request password only if it's needed
# WARNING: Autocomplete seems to cause troubles
#pacman() 
#{
#    case $1 in
#        -S | -D | -S[^sih]* | -R* | -U*)
#            /usr/bin/sudo /usr/bin/pacman "$@" ;;
#    *)      /usr/bin/pacman "$@" ;;
#    esac
#}

# List dir content after cd
function cd() {
if [ $# -eq 0 ]; then 
    builtin cd ~ && ls;
else
    builtin cd "$@" && ls;
fi 
}

unset HISTFILESIZE
export HISTSIZE=10000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="[%d/%m/%Y - %H:%M:%S] "
# appends the history instead of overwritting it (see man bash -> shopt)
shopt -s histappend

if [ -f ~/.bashrc_work ]; then
    . ~/.bashrc_work
fi

api()
{
    resource=$1;
    shift;
    if (($#==1)); then flag='-d'; else flag=''; fi;
    curl $flag "$@" -ikK ~/.st/admin https://st:444/api/v1.2/$resource;
    echo;
}
alias api=api

apiu()
{
    resource=$1;
    shift;
    if (($#==1)); then flag='-d'; else flag=''; fi;
    curl $flag "$@" -ikK ~/.st/api https://st:443/api/v1.2/$resource;
    echo;
}
alias apiu=apiu