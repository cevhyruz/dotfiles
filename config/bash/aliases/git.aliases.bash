#!/usr/bin/env bash
#
# Bash aliases for Git.

_::command_exists "git" || return 0

if _::command_exists "tig"; then
  test
fi

alias g='command git'
alias git="g"

# status
alias gss='g status --short --branch --show-stash'
alias gs='gss'
alias gsl='g status --long --show-stash'

# log
alias gl="g log"
alias glg="gl --decorate --graph --all -$(tput lines) | less"
alias glga="gl --decorate --graph --all --format=detail"

# fetching
alias gf='g fetch'
alias gfo='gf origin'
alias gfop='gf --prune'

# staging
alias ga='g add'
alias ga.='ga --all; gss'

# push
alias gp='g push'
alias gpom="g origin master"

# pull
alias gpl='g pull'

# reset (danger)
alias grs='g reset'
alias grsh='gr HEAD'
alias grsh1='gr HEAD~1'

# remote
alias grv="g remote --verbose"

# branch
alias gb='g branch'
alias gbd='gb --delete'
alias gba='gb --all'
alias gbvv="gb -vv"

# checkout
alias gco="g checkout"
alias gcob="gco -b"
alias gco-="gco -"
alias gcom="gco main 2>/dev/null || g checkout master"
alias gcod="gco develop"
