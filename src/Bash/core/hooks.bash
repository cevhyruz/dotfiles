#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2016
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# very simple implementation of Bash-preexec
#
# Globals:
# PRE_COMMAND  : commands to be run before the command.
# POST_COMMAND : commands to be run after the command.


function _exec_precmd() {
  [[ -z "${AT_PROMPT:-}" ]] && return 1
  unset AT_PROMPT

  for cmd in "${hooks_precmd[@]}"; do
    eval "$cmd"
  done
  unset cmd
}

function _exec_postcmd() {
  declare -g EXIT_CODE=$?
  declare -g AT_PROMPT=1

  [[ -n "${FIRST_PROMPT:-}" ]] && {
    unset FIRST_PROMPT
    return 1
  }

  for cmd in "${hooks_postcmd[@]}"; do
    eval "$cmd"
  done
  unset cmd
}

function ::post_command() {
  local has_cmd=0
  if (( ${#hooks_postcmd[@]} > 0 )); then
    for hook in "${hooks_postcmd[@]}"; do
      if [[ "$hook" == "$1" ]]; then
        has_cmd=1 && break
      fi
    done
    unset hook
    if [[ $has_cmd -eq 1 ]]; then
      return 0
    fi
    hooks_postcmd+=("$1")
  else
    hooks_postcmd=("$1")
  fi
}

function ::pre_command() {
  local has_cmd=0
  if (( ${#hooks_precmd[@]} > 0 )); then
    for hook in "${hooks_precmd[@]}"; do
      if [[ "$hook" == "$1" ]]; then
        has_cmd=1 && break
      fi
    done
    unset hook
    if [[ $has_cmd -eq 1 ]]; then
      return 0
    fi
    hooks_precmd+=("$1")
  else
    hooks_precmd=("$1")
  fi
}

function __init_hooks() {
  declare -ag hooks_precmd=()
  declare -ag hooks_postcmd=()

  FIRST_PROMPT=1

  # FIXME: For some reason, bash trap triggers an error
  # when inside bats. We'll skip initializing for now.
  if [[ -z "${TEST_DIRECTORY:-}" ]]; then
    trap '_exec_precmd' DEBUG
  fi

  if [[ -n $PROMPT_COMMAND ]]; then
    for cmd in "${PROMPT_COMMAND[@]}"; do
     ::post_command "$cmd"
    done
  fi

  PROMPT_COMMAND='_exec_postcmd'

}

__init_hooks && unset -f __init_hooks
