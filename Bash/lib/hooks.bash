#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Execute hook-command before and after the executing a command

function __pre_command() {
  if [[ -z "${AT_PROMPT:-}" ]]; then
    return 1
  fi

  unset AT_PROMPT

  __run_hook "${PRE_COMMAND:-}"
}

function __post_command() {
  # shellcheck disable=SC2034
  declare -g EXIT_CODE=$?

  AT_PROMPT=1

  if [[ -n "${FIRST_PROMPT:-}" ]]; then
    unset FIRST_PROMPT
    return 1
  fi

  __run_hook "${POST_COMMAND:-}"
}

function __run_hook() {
  if [[ -z "$1" ]]; then
    return 1
  else
    local hook="$1"
  fi
  if [[ -n "${hook:-}" ]]; then
    eval "${hook}"
  fi
}
