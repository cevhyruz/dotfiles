#!/usr/bin/env bash
# shellcheck shell=bash source=/dev/null
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Lazyload nvm (Node Version Manager) if it is present.
# config:
#   lazyload_nvm=[true|false]

function main() {
  declare -g NVM_DIR="${HOME}/.nvm"
  declare -ag exposed_funcs=("nvim" "node" "npm" "npx")

  if [[ -d $NVM_DIR ]]; then
    if [[ $lazyload_nvm == true ]]; then
      lazyload_nvm
     else
      load_nvm_normally
    fi
  fi
}

function lazyload_nvm() {
  for func in nvm node npm npx; do
    eval "function $func() {
      local NVIM_DIR=$NVM_DIR
      unset -f $func
      load_nvm_normally
      \\$func \"\$@\"
    }"
  done
  unset -v func NVM_DIR
}

function load_nvm_normally() {
  if command -v brew &>/dev/null &&
    [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"
  elif [[ -s "${NVM_DIR}/nvm.sh" ]]; then
    source "${NVM_DIR}/nvm.sh"
  fi
  if [[ -f "${NVM_DIR}/bash_completion" ]]; then
    source "${NVM_DIR}/bash_completion"
  fi
  unset -v NVM_DIR
}

function cleanup() {
  unset -v exposed_funcs
  unset -f main lazyload_nvm cleanup
  unset -v lazyload_nvm
}

main && cleanup
