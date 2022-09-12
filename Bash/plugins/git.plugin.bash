#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2207,SC2181,SC2154
#
# A Git wrapper so illegal, it should be awesome!

_::command_exists "git" || return 0

function git() {
  local method="${1:-}"
  local exit_code

  load "${GIT_ALIAS:-${HOME}/.config/git}/.gitalias.bash"

  if [[ -z "${method}" ]]; then
    unload
    command git
    return $?
  fi

  if declare -F "${method}" &> /dev/null; then
    echo "    This is from aliases"
    shift
    "${method}" "$@"
    exit_code=$?
    unload
    return $exit_code
  fi

  unload
    echo "    This is from git"
  command git "$@" \
    || printf "\n%s\n" "Similar alias loaded from Git/.gitalias.bash:"
}

function load() {
  local file="$1"
  local namespace="${file//[\/\.]/\_}"

  source "${file}" || return

  declare -ag  _git_func=($(
    grep -Eo 'function[[:space:]]+[[:alnum:]_]+' "${file}" | awk '{ print $2 }'
  ))
}

function unload() {
  for entry in "${_git_func[@]}"; do
    declare -f $entry
  done
}

