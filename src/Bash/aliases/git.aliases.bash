#!/usr/bin/env bash
#
# Bash aliases for Git.

_::command_exists "git" || return 0

if _::command_exists "tig"; then
  test
fi

# alias t='tmux'

alias g='git'

# add
alias ga='git add'
alias gall='git add --all'
alias gap='git add --patch'

alias lola="g status -s"

# branching
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'

alias gba='git branch --all'
alias gbm='git branch --move'
alias gbt='git branch --track'
