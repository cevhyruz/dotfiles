# allow sudo'ing aliases
alias sudo="sudo "
alias reload='exec "${SHELL}"'

function song() {
  lsof -c mplayer | fgrep ".webm" | awk -F"/" '{ print $NF; }'
}

alias ex="echo disables vim ex mode"

alias please="fuck"

alias exa="exa --colour=always -la"

alias mv="mv --interactive"

# list all which matches
alias which="which -a"

# pretty print path names
alias path='printf "%b" "${PATH//:/\\n}" | fzf'
alias envars='printenv | fzf'

alias coverage='echo -e "$(cat /home/devs/Projects/dotfiles/destinnation.back)" | fzf --ansi'

# which spawns the current shell
alias parent='ps --no-headers -o comm "${PPID}"'

alias r="reset"
alias cr="clear"

# alias wpm="TERM='xterm-256color' wpm"

alias q="exit"
alias c="clear"

alias open="xdg-open"

# navigation
alias -- -='cd -'

alias ls='ls --color=always --almost-all --group-directories-first'
alias dir='dir --color=always --almost-all --group-directories-first --dereference'

# copy paste
if [[ $(command -v xclip) ]]; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -out"
fi

# bird's eye view of directory
if [[ $(command -v tree) ]]; then
  alias tre="tree -a -C -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX"
fi

alias gt='gulp --tasks'

alias npmlg="npm list --global --depth 0";

# sysmtemd service

alias sc='systemctl'
alias scr='systemctl daemon-reload'
alias scu='systemctl --user'
alias scur='systemctl --user daemon-reload'
alias sce='systemctl stop'
alias scue='systemctl --user stop'
alias scs='systemctl start'
alias scus='systemctl --user start'

# terminal multiplexer

alias ta='tmux attach -t'
alias tls='tmux list-session'
alias tnew='tmux new -s'

alias g='git'
