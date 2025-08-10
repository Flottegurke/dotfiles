#
# ~/.bashrc
#

# --------------------General setup--------------------
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# set historty filesize
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# initialise starship
eval "$(starship init bash)"
# initialise zoxide to replace "cd"
eval "$(zoxide init --cmd cd bash)"
# initialise fzf (use custom cappuccin color theme)
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#313244,label:#CDD6F4"

export VISUAL=vim
export EDITOR=vim

# --------------------Aliases--------------------
alias fzf='fzf --preview="bat --color=always --line-range 0:500 {}"'
alias fzfo='file="$(fzf)" && [ -n "$file" ] && file="$(realpath "$file")" && history -s "vim \"$file\"" && vim "$file"'
alias fzfc='file="$(fzf)" && [ -n "$file" ] && file="$(realpath "$file")" && wl-copy "$file"'
alias fzffc='file="$(fzf)" && [ -n "$file" ] && file="$(realpath "$file")" && cat "$file" | wl-copy'

alias ls='exa --icons=auto --color=auto'
alias ll='ls -al'
alias la='ls -A'

alias lgit=lazygit
alias icat='kitten icat'
alias hg='kitten hyperlinked-grep'

alias grep='grep --color=auto'

alias ssh-tui='python3 ~/Programming/ssh-tui/main.py'

# Add an "alert" alias for long running commands.  Use like this:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo system-run || echo dialog-warning)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

ndir() { mkdir "$1" && cd "$1"; }

# Enable programmable completion features (see /etc/bash_completion)
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# This allows for personal .bashrc configs which are not tracked by git
source ~/.config/customBashrc
