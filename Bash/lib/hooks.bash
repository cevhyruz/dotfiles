#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Execute hook-command before and after the executing a command

[[ -n ${HOOKS_LOADED:-} ]] && return 1 || HOOKS_LOADED=true

function pre_command() {
  if [[ -z "${AT_PROMPT:-}" ]]; then
    return 1
  fi
  unset AT_PROMPT

  _run_hook "${PRE_COMMAND:-}"
}

function post_command() {
  # shellcheck disable=SC2034
  typeset -g EXIT_CODE=$?

  AT_PROMPT=1

  if [[ -n "${FIRST_PROMPT:-}" ]]; then
    unset FIRST_PROMPT
    return 1
  fi

  _run_hook "${POST_COMMAND:-}"
}

function _run_hook() {
  if [[ -z "$1" ]]; then
    return 1
  else
    local hook="$1"
  fi

  if [[ -n "${hook:-}" ]]; then
    eval "${hook}"
  fi
}
