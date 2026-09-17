#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# lib/utils.sh — general-purpose predicates and small helpers with
# no side effects on shell state, callable anytime.


# check if a given command is exists
# Args [command]
# Returns:
#  0 if command exists on path, 1 otherwise
__util::command_exists() {
  local cmd="${1:-}"
  if command -v "${cmd}" &>/dev/null; then
    return 0
  fi
  return 1
}


# Add/prepend [path] into the global environment path.
# param [path]
# return 0 if the [path] was successfully added, 1 otherwise.
__util::add_to_path() {
  if [[ -d ${1:-} && ! $PATH =~ (^|:)"${1}"($|:) ]]; then
    if [[ ${2:-before} == "after" ]]; then
      export PATH="${PATH}:$1"
    else
      export PATH="$1:${PATH}"
    fi
    return
  fi
}

# Returns 0 if the terminal (per $TERM) supports 256+ colors
# __TERM_COLORS_COUNT is computed once at startup (see: core/envars.bash)
__util::supports_color() {
  if [[ "${COLORTERM-}" =~ ^(truecolor|24bit)$ ]]; then
    __TERM_COLOR_SUPPORT=true
    return 0
  fi
  (( __TERM_COLORS_COUNT >= 256 ))
}

# make prompt var that changes value depending on last command return status.
# TODO: This doesn't belong here
# @param1: variable to store colors
# @param2: value of the variable when last command is true
# @param3: value of the variable when last command is false
#
function _make_prompt_var() {
  if [[ "${ret:-${EXIT_CODE-}}" -eq 0 ]]; then
    eval "declare -g $1=\"$2\""
  else
    eval "declare -g $1=\"$3\""
  fi
}
