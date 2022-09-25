#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2207,SC2181,SC2154
#
# A Git wrapper so illegal, it should be awesome!

_::command_exists "git" || return 0

# @FIXME: move this to the Git wrapper call to reduce Bash startup time.
git_alias_funcs=($(
  grep --extended-regexp --only-matching 'function[[:space:]]+[[:alnum:]_]+' \
    "${git_alias_path}/.gitalias.bash" | awk '{ print $2 }'
))

function git() {
  local method="${1:-}"
  local -r git_alias="${git_alias_path}/.gitalias.bash"

  function unload() {
    for declaration in "${git_alias_funcs[@]}"; do
      unset -f "$declaration"
    done
    unset -v declaration
    unset -f unload
  }

  source "$git_alias" \
    || echo "failed loading '${git_alias}'"

  if [[ -z "${method}" ]]; then
    unload
    command git
    return $?
  fi

  # git aliases
  if declare -F "${method}" &> /dev/null; then
    shift
    "${method}" "$@"
    exit_code=$?
    unload
    return $exit_code
  fi

  # actual git command
  unload
  command git "$@" \
    || printf "\n%s\n" "Similar alias loaded from Git/.gitalias.bash:"
}
