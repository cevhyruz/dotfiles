#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=sh fdm=marker ts=2 sw=2 et
#
# Core aliases that I use for a daily basis.

# allow sudo'ing aliases.
alias sudo="sudo "

# show all function definitions in a script.
alias scriptinfo="grep -Eow 'function[[:space:]]+[[:alnum:]_]+'"

# prompt whether to remove destinations.
alias ln="ln --interactive "

#  time scriptinfo "${DOT_BASH}/plugins/fzf.plugin.bash" | awk '{print $2}'

# going home.
alias home='cd ${HOME}'

# reload current shell session.
alias reload='exec "${SHELL}"'

# always use mv interactively.
alias mv="mv --interactive"

# always list all matches.
alias which="which -a"

# pretty print path names.
alias path='echo "${PATH//:/\\n}"'
alias rtp='printf "%s\n" "$(echo ${LOADER_PATH[*]})"'

# list enabled bash options.
if ! declare -F bashopts &>/dev/null; then
  alias bashopts='printf "%b\n" "${BASHOPTS//:/\\n}"'
fi

if [[ -x "/usr/bin/dircolors" ]]; then
  alias dir="dir --color=always"
  alias egrep="egrep --color=always"
  alias fgrep="fgrep --color=always"
  alias grep="grep --color=always"
  alias lscolor="ls --color=always"
  alias vdir="vdir --color=always"
fi

# print which spawns the current shell session.
alias parent='ps --no-headers -o comm "${PPID}"'

# list files with TODO: and FIXME: notation
alias todo="grep --recursive 'TOD[O]: '"
alias fixme="grep --recursive 'FIXM[E]: '"

# quit shell session.
alias q="exit"
alias c="clear"

# go back to the previous directory.
alias -- -="cd -"

# sensible file listing.
alias ls="ls --color=always --almost-all --group-directories-first"
alias dir="dir --color=always --almost-all --group-directories-first --dereference"

# engine sounds (useful for testing).
alias engage='play -n -c1 synth whitenoise band -n 100 20 band -n 50 20 gain +25  fade h 1 864000 1'
alias engage2='play -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +16'
