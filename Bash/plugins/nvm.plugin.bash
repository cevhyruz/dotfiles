#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

# shellcheck source=/dev/null
# Node version manager Plugin for Bash
#
# load nvm (Node Version Manager) if it is present.
#
# Globals:
#   LAZYLOAD_NVM (default 0)
#   set to 1 to enable loading nvm on-demand, 0 otherwise.

function _set_nvm() {
  # If these two functions are present, then nvm is installed.
  if ! declare -F 'nvm' && ! declare -F 'nvm_echo'; then
    if [[ -d "${HOME}/.nvm" ]]; then
      export NVM_DIR="$HOME/.nvm"

      # load nvm on-demand.
      if [[ "${LAZYLOAD_NVM:-0}" -eq 1 ]]; then
        echo 'on-demand'
        _lazy_load_nvm
        return 0
      fi
      # load nvm normally.
      _load_script_files
      echo 'loaded normally'

      return 0
    fi

    echo 'nothing'
    _set_nvm::_cleanup
    return 1
  fi
}

function _lazy_load_nvm() {
  for func in nvm node npm npx; do
    eval "${func}() {
      #if [[ -n ${assert_call:-} ]]; then
        #return 0
      #fi
      _load_script_files
      ${func} \"\$@\"
    }"
  done
  unset func
}

function _load_script_files() {
  #if [[ "${LAZYLOAD_NVM:-0}" -eq 1 ]]; then
  unset -f nvm node npm npx
  #fi
  _load_nvm_script
  _load_nvm_bash_compl
}

function _load_nvm_script() {
  if command -v brew &>/dev/null &&
    [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"
  elif [[ -s "${NVM_DIR}/nvm.sh" ]]; then
    source "${NVM_DIR}/nvm.sh"
  fi
}

function _load_nvm_bash_compl() {
  if [[ -f "${NVM_DIR}/bash_completion" ]]; then
    source "${NVM_DIR}/bash_completion"
  fi
}

function _set_nvm::_cleanup() {
  unset -f _set_nvm \
    _lazy_load_nvm \
    _load_script_files \
    _load_nvm_script \
    _load_nvm_bash_compl \
    _set_nvm::_cleanup
}

_set_nvm
