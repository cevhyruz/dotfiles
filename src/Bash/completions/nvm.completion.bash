#!/usr/bin/env bash
# shellcheck shell=bash source=/dev/null
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Completion file for nvm

# nvm already ships it's own bash completion,
# we'll just modify the options since it's not yet included.

if [[ -f "${NVM_DIR}/bash_completion" ]]; then
  source ~/.nvm/bash_completion
fi

function __nvm_options() {
  OPTIONS='-h --help --version --no-colors'
  __nvm_generate_completion "${OPTIONS}"
}
