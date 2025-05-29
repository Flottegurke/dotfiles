#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias grep='grep --color=auto'

alias ls='exa --icons --color=always'

eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"


eval "$(fzf --bash)"
alias fzf='fzf --preview="bat --color=always --line-range 0:500 {}"'
alias fzfo='nano $(fzf)'
alias fzfc='fzf | wl-copy'
