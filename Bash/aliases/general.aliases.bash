#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=sh fdm=marker ts=2 sw=2 et
#
# Core aliases that I use for a daily basis.

# allow sudo'ing aliases.
alias sudo="sudo "

# prompt whether to remove destinations.
alias ln="ln --interactive "

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
