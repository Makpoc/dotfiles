# From bashrc:
test -s ~/.alias && . ~/.alias || true

export EDITOR=vim
export PATH=$PATH:/opt/java/bin:~/bin:~/scripts

export GOPATH=~/git/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN


fpath=(~/.config/zsh/comp/ $fpath)

# autocomplete:
#zstyle :compinstall filename '/home/makpoc/.zshrc'

setopt auto_param_slash
setopt COMPLETE_ALIASES            # complete aliases

setopt NO_NOMATCH           # if extended glob fails, run cmd as-is
setopt NO_CASE_GLOB         # ignore case in glob searches

setopt rcquotes
setopt nocasematch          # regex should work case-insensitive
setopt magic_equal_subst    # enable path autocompletion after =

setopt autocd               # 'cd /usr/' is now '/usr/'

#WORDCHARS=' *?_-.[]~=&;!#$%^90{}<>'  # what kill word shoud delete
WORDCHARS='*?_-~=&!%^90'  # what kill word shoud delete

# History
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=1000
HISTTIMEFORMAT="[%d/%m/%Y - %H:%M:%S] "
SAVEHIST=1000
setopt appendhistory sharehistory

unsetopt beep
bindkey -e

# Colors
eval $(dircolors)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # supposed to add colors to completion menu
autoload -Uz colors && colors

# delete/up/down/home/end fix
# not working
#autoload -Uz zkbd
#if [[ -f ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}  ]]; then
#    source ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
#else
#    echo "WARNING: Keybindings may not be set correctly!"
#    echo "Execute \`zkbd\` to create bindings."
#fi

# key bindings for terminal emulator
if [ "$TERM" =~ rxvt ]; then
    bindkey "\e[3~"   delete-char           # delete
    bindkey '\e[1~'   beginning-of-line     # home and ctrl+home
    bindkey '\e[4~'   end-of-line           # end and ctrl+end
    bindkey '^H'      backward-kill-word    # ctrl+backspace
    bindkey "^[3^"    kill-word             # ctrl+delete
    bindkey '\eOd'    backward-word         # ctrl+left
    bindkey '\eOc'    forward-word          # ctrl+right
    bindkey '\e[1;5I' 'beep'                # disable ctrl+tab
    bindkey '\e[1;6I' 'beep'                # disable ctrl+shift+tab
else
    bindkey "\e[3~"   delete-char           # delete
    bindkey '\eOH'    beginning-of-line     # home
    bindkey '\eOF'    end-of-line           # end
    bindkey ';5H'     beginning-of-line     # ctrl+home
    bindkey ';5F'     end-of-line           # ctrl+end
    bindkey '^_'      backward-kill-word    # ctrl+backspace
    bindkey "\e[3;5~" kill-word             # ctrl+delete
    bindkey ';5D'     backward-word         # ctrl+left
    bindkey ';5C'     forward-word          # ctrl+right
    bindkey '\e[1;5I' 'beep'                # disable ctrl+tab
    bindkey '\e[1;6I' 'beep'                # disable ctrl+shift+tab
fi
# *** PROMPT FORMATTING ***
# Echoes a username/host string when connected over SSH (empty otherwise)
ssh_info() {
    [[ "$SSH_CONNECTION" != '' ]] && echo '%(!.%{$fg[red]%}.%{$fg[yellow]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:' || echo ''
}

# Change the prompt character color if the last command had a nonzero exit code
PS1="%(?.%{$fg[white]%}.%{$fg[red]%})%(!.#.┌─)%{$reset_color%}[%{$fg[yellow]%}%n%{$reset_color%}::%{$fg[white]%}%m%{$reset_color%}][%{$fg[green]%}%~%u%{$reset_color%}]
%(?.%{$fg[white]%}.%{$fg[red]%})%(!.#.└─╼)%{$reset_color%} "

# load all zsh additional config files
zshconf="$HOME/.config/zsh"
[[ -d $zshconf ]] && for f in $zshconf/*.zsh; do source "$f"; done 

# Experimental:
# first: pacman -S zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export CDPATH=$CDPATH:$GOPATH/src
source /usr/share/nvm/init-nvm.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
