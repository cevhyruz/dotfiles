#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2207,SC2181
#
# A Git wrapper so illegal, it should be awesome!

_::command_exists "git" || return 0

export git_core_loaded=1

function git() {
  local method="${1:-}"
  local exit_code

  _::load "${GIT_ALIAS}/.gitalias.bash" "git_aliases"

  if [[ -z "${method}" ]]; then
    unload "git_aliases"
    command git
    return $?
  fi

  if declare -F "${method}" &> /dev/null; then
    shift
    "${method}" "$@"
    exit_code=$?
    unload "git_aliases"
    return $exit_code
  fi

  unload "git_aliases"
  command git "$@" \
    || printf "\n%s\n" "Similar alias loaded from Git/.gitalias.bash:"
}
