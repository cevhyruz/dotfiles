#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2016
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Execute an array or commands delimited by ';'
# before and after the shell command.
#
# Globals:
# PRE_COMMAND  : commands to be run before the command.
# POST_COMMAND : commands to be run after the command.
# EXIT_CODE    : exit status of the given command.

function __pre_command() {
  if [[ -z "${AT_PROMPT:-}" ]]; then
    return 1
  fi
  unset AT_PROMPT
  eval "${PRE_COMMAND[@]}"
}

function __post_command() {
  declare -g EXIT_CODE="$?"
  AT_PROMPT=1
  if [[ -n "${FIRST_PROMPT:-}" ]]; then
    unset FIRST_PROMPT
    return 1
  fi
  eval "${POST_COMMAND[@]}"
}

function __init_hooks() { # something
  declare -a PRE_COMMAND=()
  declare -a POST_COMMAND=()

  # avoid __post_command pre-firing before the first prompt.
  FIRST_PROMPT=1

  # FIXME: For some reason, bash trap triggers an error
  # when inside bats. We'll skip initializing for now.
  if [[ -z "${TEST_DIRECTORY:-}" ]]; then
    trap '__pre_command' DEBUG
  fi

  # fireup __post_command after every prompt
  # and pass previous command return status.
  PROMPT_COMMAND+=('__post_command;')
}

__init_hooks && unset -f __init_hooks
