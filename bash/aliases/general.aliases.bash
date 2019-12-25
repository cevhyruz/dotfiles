# allow sudoing aliases
alias sudo='sudo '
alias h='help'

alias reload='exec ${SHELL}'
alias ex='echo disables vim ex mode'

alias tre="tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX"

# map capslock to backspace and double shift to capslock,
# and make capslock (now backspace) repeatable when on-hold.
alias k='setxkbmap -option caps:backspace -option shift:both_capslock && xset r 66'

alias which="which -a"

# pretty print pathnames
alias path='printf "%b" "${PATH//:/\\n}"'

# which spawns the current shell?
alias parent='ps --no-headers -o comm "${PPID}"'

# list files with TODO: and FIXME: notation
alias todo="grep --recursive 'TOD[O]: '"
alias fixme="grep --recursive 'FIXM[E]: '"

alias e="exit"
alias q="exit"
alias c="clear"

alias open="xdg-open"

# navigation
alias -- -='cd -'

# language aliases
alias py='python'

# packages
alias ls='ls --color=always --almost-all --group-directories-first --classify'
alias dir='dir --color=always --almost-all --group-directories-first --dereference'

alias dircolor="dir --color=always"
alias egrep="egrep --color=always"
alias fgrep="fgrep --color=always"
alias grep="grep --color=always"
alias lscolor="ls --color=always"
alias vdir="vdir --color=always"
