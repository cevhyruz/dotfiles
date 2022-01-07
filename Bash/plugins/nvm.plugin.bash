#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

# shellcheck source=/dev/null
# Node version manager Plugin for Bash
#
# load nvm (Node Version Manager) if it is present.
#
# Globals:
#   LAZYLOAD_NVM (default: 1)
#   set to 0 to disable lazy loading nvm, 1 otherwise

# ENVIRONMENT:
# these function will be set by default if lazyloading is enabled.
# npm, node, npm, npx.

function __set_nvm() {
  export NVM_DIR="${HOME}/.nvm"

  if [[ -d "${NVM_DIR}" ]]; then
    case "${LAZYLOAD_NVM:-1}" in
    1 | true | TRUE | yes | YES)
      __lazy_load_nvm
      ;;
    0 | false | FALSE | no | NO)
      __load_script_files
      ;;
    esac
  fi
  __cleanup
}

function __load_script_files() {
  # bootstrap nvm
  if command -v brew &>/dev/null &&
    [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"
  elif [[ -s "${NVM_DIR}/nvm.sh" ]]; then
    source "${NVM_DIR}/nvm.sh"
  fi
  # load completion
  if [[ -f "${NVM_DIR}/bash_completion" ]]; then
    source "${NVM_DIR}/bash_completion"
  fi
}

function __lazy_load_nvm() {
  for func in nvm node npm npx; do
    eval "function ${func}() {
       unset -f ${func};
       $(declare -f __load_script_files | tail +3 | head)
      ${func} \"\$@\"
    }"
  done
  unset func
}

function __cleanup() {
  unset -f \
    __set_nvm \
    __lazy_load_nvm \
    __load_script_files \
    __cleanup
}

__set_nvm
