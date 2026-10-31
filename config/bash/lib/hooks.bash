#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2016
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Minimal bash-preexec.
#
# API:
#   ::pre_command  CMD   run CMD before each command
#   ::post_command CMD   run CMD before each prompt/after each command
#                        (EXIT_CODE holds the last status)
#
# Requires bash 4.3+ (namerefs).

# Guard against double-sourcing: re-adopting our own PROMPT_COMMAND
# would make _exec_postcmd call itself forever.
[[ -n "${_HOOKS_LOADED:-}" ]] && return 0
_HOOKS_LOADED=1

declare -ag hooks_precmd=() hooks_postcmd=()

# Append $2 to the array named $1 unless it is already there.
function _hook_add() {
  local -n _hooks=$1
  local _h
  for _h in "${_hooks[@]}"; do
    [[ "$_h" == "$2" ]] && return 0
  done
  _hooks+=("$2")
}

# Remove every occurrence of $2 from the array named $1.
function _hook_remove() {
  local -n _hooks=$1
  local _h _keep=()
  for _h in "${_hooks[@]}"; do
    [[ "$_h" == "$2" ]] || _keep+=("$_h")
  done
  _hooks=("${_keep[@]}")
}

function ::remove_post_command() { _hook_remove hooks_postcmd "$1"; }

# Run every entry of the array named $1.
function _hook_run() {
  local -n _hooks=$1
  local _cmd
  for _cmd in "${_hooks[@]}"; do
    eval "$_cmd"
  done
}

function ::pre_command()  { _hook_add hooks_precmd  "$1"; }
function ::post_command() { _hook_add hooks_postcmd "$1"; }

# DEBUG trap: fires before every simple command, so AT_PROMPT makes
# the hooks run only once per prompt.
function _exec_precmd() {
  case $BASH_COMMAND in _exec_postcmd|_footer_*) return 0 ;; esac   # our own traps, not user commands
  [[ -n "${AT_PROMPT:-}" ]] || return 0
  # Inside a `bind -x` handler: not a user command, leave AT_PROMPT set
  [[ -v READLINE_LINE ]] && return 0
  unset AT_PROMPT
  _hook_run hooks_precmd
}

function _exec_precmd() {
  [[ -n "${AT_PROMPT:-}" ]] || return 0
  [[ -v READLINE_LINE ]] && return 0
  unset AT_PROMPT
  _hook_run hooks_precmd
  HOOK_CMD_START=${EPOCHREALTIME/./}    # last thing before the command runs
}

function _exec_precmd() {
  [[ -n "${AT_PROMPT:-}" ]] || return 0
  [[ -v READLINE_LINE ]] && return 0
  declare -g HOOK_CMD=$BASH_COMMAND      # the command about to run
  unset AT_PROMPT
  _hook_run hooks_precmd
  HOOK_CMD_START=${EPOCHREALTIME/./}
}

# PROMPT_COMMAND entry point. Must capture $? first.
function _exec_postcmd() {
  declare -g EXIT_CODE=$?
  declare -g AT_PROMPT=1

  # Nothing has run yet on the very first prompt.
  # if [[ -n "${FIRST_PROMPT:-}" ]]; then
  #   unset FIRST_PROMPT
  #   return 0
  # fi

  _hook_run hooks_postcmd
  return "$EXIT_CODE"
}

function _exec_postcmd() {
  declare -g EXIT_CODE=$?
  declare -g HOOK_CMD_END=${EPOCHREALTIME/./}   # first thing after it ends
  declare -g AT_PROMPT=1
  _hook_run hooks_postcmd
  return "$EXIT_CODE"
}

function __init_hooks() {
  # FIRST_PROMPT=1

  # The DEBUG trap misbehaves under bats, so skip it there.
  # NOTE: This overwrites any existing DEBUG trap.
  [[ -z "${TEST_DIRECTORY:-}" ]] && trap '_exec_precmd' DEBUG

  # Adopt whatever is in PROMPT_COMMAND (string or array).
  local cmd
  for cmd in "${PROMPT_COMMAND[@]}"; do
    [[ -n "$cmd" ]] && ::post_command "$cmd"
  done

  PROMPT_COMMAND='_exec_postcmd'
}

__init_hooks && unset -f __init_hooks
