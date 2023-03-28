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

# TODO:
# [x] Add return status.
# [x] Merge the same stack (tree-like view).
# [x] Dim color for stdout.
function _ps4_callstack() {
  set +u
  for (( i = ${#FUNCNAME[@]}; i > 0; i-- )); do
    printf  '\e[38;5;5m%b\e[36m:%b:\e[38;5;187m%b\e[0m \e[31m>\e[0m ' \
      "${BASH_SOURCE[i]##*/}" "${BASH_LINENO[i]}" "${FUNCNAME[i]}()"
  done
  set -u
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

  command git update-index --really-refresh

  command git diff --quiet --ignore-submodules --cached ||
    status+="+"

  command git diff-files --quiet --ignore-submodules -- ||
    status+="!"

  test -n "$(command git ls-files --others --exclude-standard :/)" &&
    status+="?"

  command git rev-parse --verify refs/stash &> /dev/null &&
    status+="*"

  printf "%b" "\[${1-$Bgwhite}\] ${status}"
  status=''
}
