#!/usr/bin/env bash
# shellcheck shell=bash source=/dev/null
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Completion file for nvm

# nvm already ships it's own bash completion,
# this is for when we want to override or add a completion.

if [[ -z "${NVM_DIR-}" ]] then
  return
fi

if [[ -f "${NVM_DIR}/bash_completion" ]]; then
  source ~/.nvm/bash_completion
fi

# additional option completion.
function __nvm_options() {
  OPTIONS='-h --help --version --no-colors'
  __nvm_generate_completion "${OPTIONS}"
}
