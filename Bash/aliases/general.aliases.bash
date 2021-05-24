#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Core aliases that I use for a daily basis.

# allow sudo'ing aliases.
alias sudo="sudo "

# going home.
alias home='cd "${HOME}"'

# reload current shell session.
alias reload='exec "${SHELL}"'

# always use mv interactively.
alias mv="mv --interactive"

# always list all matches.
alias which="which -a"

# pretty print path names.
alias path='echo "${PATH//:/\\n}"'

# print which spawns the current shell session.
alias parent='ps --no-headers -o comm "${PPID}"'

# quit shell session.
alias q="exit"

# go back to the previous directory.
alias -- -="cd -"

# sensible file listing.
alias ls="ls --color=always --almost-all --group-directories-first"
alias dir="dir --color=always --almost-all --group-directories-first --dereference"
