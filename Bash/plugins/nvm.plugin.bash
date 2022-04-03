#!/usr/bin/env bash
# shellcheck shell=bash source=/dev/null
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Lazyload nvm (Node Version Manager) if it is present.

# Globals:
#   LAZYLOAD_NVM (default: 1         )
#   NVM_DIR      (default: $HOME/.nvm)

export LAZYLOAD_NVM=0

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
       unset -f ${func}
       __load_script_files
      \\${func} \"\$@\"
    }"
  done
  unset func
  #function nvm() {
    #unset -f nvm
  #}
}

function __cleanup() {
  unset -f \
    __set_nvm \
    __lazy_load_nvm \
    __cleanup
}

__set_nvm
