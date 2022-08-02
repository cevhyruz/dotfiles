#!/usr/bin/env bash
#
# helper functions for constructing your bash prompts.

# if [[ "${FROM_PROMPT:-}" -ne 1 ]]; then
#   return 0
# fi

# last command status
# usage: _last_command_status [true] [false]
# sample: _last_command_status "" "[ exited ${EXIT_CODE} ]"
function _last_command_status_ok() {
  if [[ ${EXIT_CODE:-} -eq 0 ]]; then
    printf "%b" "${1}"
  else
    printf "%b" "${2}"
  fi
}
