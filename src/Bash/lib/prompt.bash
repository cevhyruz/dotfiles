#!/usr/bin/env bash
#
# Helper functions for building bash prompt

# make prompt var that changes value depending on last command return status.
# @param1: variable to store colors
# @param2: value of the variable when last command is true
# @param3: value of the variable when last command is false
#
function _make_prompt_var() {
  if [[ "${EXIT_CODE:-}" -eq 0 ]]; then
    eval "declare -g $1=\"$2\""
  else
    eval "declare -g $1=\"$3\""
  fi
}

function _prompt_git_head() {
  local git_head

  _::is_git_repo || return

   git_head="$(
    command git symbolic-ref --quiet --short HEAD 2> /dev/null ||
    command git rev-parse --short HEAD 2> /dev/null ||
    printf "unknown" )"

  if [[ "${git_head}" =~ (main|master) ]]; then
    printf "${4:- }\[${2}\]${git_head}"
  elif [[ "${git_head}" =~ [0-9]+ ]]; then
    printf "${4:- }\[${3}\]${git_head}"
  else
    printf "${4:- }\[${1}\]${git_head}"
  fi
}

# show git status
# @param1: [something]
#
function _prompt_git_status() {
  local status=''

  _::is_git_repo || return

  command git diff --quiet --ignore-submodules --cached ||
    status+="+"

  command git diff-files --quiet --ignore-submodules ||
    status+="!"

  test -n "$( command git ls-files --others --exclude-standard :/ )" &&
    status+="?"

  command git rev-parse --verify refs/stash &> /dev/null &&
    status+="*"

  printf "%b" "\[${1-$Bgwhite}\] ${status}"
  unset -v status
}
