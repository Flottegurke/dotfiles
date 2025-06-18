#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"

eval "$(fzf --bash)"
alias fzf='fzf --preview="bat --color=always --line-range 0:500 {}"'
alias fzfo='file=$(fzf) && history -s "nano \"$file\"" && nano "$file"'
alias fzfc='fzf | wl-copy'

alias grep='grep --color=auto'
alias ls='exa --icons=auto --color=auto'
alias ll='ls -al'
alias la='ls -A'

alias lgit=lazygit

alias ssh-tui='python3 ~/Programming/ssh-tui/main.py'
alias ssh-keygen-helper=' bash ~/Programming/flotte-linux-utils/ssh/ssh-key/ssh-keygen-helper/ssh-keygen-helper.sh'
alias ssh-keypush-helper=' bash ~/Programming/flotte-linux-utils/ssh/ssh-key/ssh-keypush-helper/ssh-keypush-helper.sh'

# Add an "alert" alias for long running commands.  Use like this:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo system-run || echo dialog-warning)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Enable programmable completion features (see /etc/bash_completion)
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi
