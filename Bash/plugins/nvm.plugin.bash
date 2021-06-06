#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

# shellcheck source=/dev/null
# Node version manager Plugin for Bash
#
# load nvm on-demand to make bash startup faster.

# We can't really test if nvm exist like 'command -v nvm',
# so we'll just check if the default installation dir exists.
if ! [[ -d "${HOME}/.nvm" ]] ||
  which -a node &>/dev/null; then
  return 1
fi

function _load_nvm() {
  NVM_DIR="${HOME}/.nvm"

  for func in nvm node npm npx; do
    eval "${func}() {
      _load_nvm::_lazy_load
      ${func} \"\$@\"
    }"
  done
  unset func
}

function _load_nvm::_lazy_load() {
  unset -f nvm \
    node \
    npm \
    npx

  _load_nvm::_load_script
  _load_nvm::_bash_compl
}

function _load_nvm::_load_script() {
  if command -v brew &>/dev/null &&
    [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"
  elif [[ -s "${NVM_DIR}/nvm.sh" ]]; then
    source "${NVM_DIR}/nvm.sh"
  fi
}

function _load_nvm::_bash_compl() {
  if [[ -f "${NVM_DIR}/bash_completion" ]]; then
    source "${NVM_DIR}/bash_completion"
  fi
}

_load_nvm
