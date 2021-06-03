#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

function main() {
  for func in nvm node npm npx; do
    eval "${func}() { _lazyload_nvm && ${func} \"\$@\"; }"
  done
  unset func
}

function _lazyload_nvm() {
  NVM_DIR="${HOME}/.nvm"
  unset -f nvm node npm npx

  _load_nvm
  _load_nvm_bash_compl
}

function _load_nvm() {
  if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
    source "${NVM_DIR}/nvm.sh"
  fi
}

function _load_nvm_bash_compl() {
  if [[ -f "${NVM_DIR}/bash_completion" ]]; then
    source "${NVM_DIR}/bash_completion"
  fi
}

main
