#!/usr/bin/env bash
# shellcheck shell=bash source=/dev/null disable=SC2162
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# lazyload nvm

if ! [[ -d "${XDG_CONFIG_HOME-}/.nvm" ]] && ! [[ -d "${HOME}/.nvm" ]] then
  return
fi

function main() {
  if [[ -z "${XDG_CONFIG_HOME-}" ]]; then
    export NVM_DIR="${HOME}/.nvm"
  else
    export NVM_DIR="${XDG_CONFIG_HOME-}/nvm"
  fi

  local default
  read default < "${NVM_DIR}/alias/default"
  if [[ -d "${NVM_DIR}" ]]; then
    _::add_to_path "${NVM_DIR}/versions/node/v${default}"*"/bin"
  fi
}

function nvm() {
  source "${NVM_DIR}"/nvm.sh &&
    nvm "$@";
}

main
