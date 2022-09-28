#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2207,SC2181,SC2154
#
# A Git wrapper so illegal, it should be awesome!

_::command_exists "git" || return 0

function git() {
  local method="${1:-}"
  local git_alias="${git_alias_path}/.gitalias.bash"
  local git_alias_funcs=($( bash -c ". $git_alias; declare -F" ))

  function unload() {
    for declaration in "${git_alias_funcs[@]}"; do
      unset -f "$declaration"
    done
    unset -v declaration
    unset -f unload
  }

  source "$git_alias" || echo "failed loading '${git_alias}'"
  trap "trap RETURN && unload" RETURN

  # just an empty git command
  if [[ -z "${method}" ]]; then
    command git
    return $?
  fi

  # git aliases
  if declare -F "${method}" &> /dev/null; then
    shift && "${method}" "$@"
    exit_code=$?
    return $exit_code
  fi

  # actual git command
  command git "$@" \
    || printf "\n%s\n" "Similar alias loaded from Git/.gitalias.bash:"
}
