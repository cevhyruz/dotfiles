#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

about-plugin 'Load pyenv, if it is installed.'
plugin-group 'wrappers'

export PYENV_ROOT="${HOME}/.pyenv"

if [[ ! -d ${PYENV_ROOT} ]] \
  || [[ ! -x "${PYENV_ROOT}/bin/pyenv" ]]; then
  unset -v PYENV_ROOT
  return 0
fi

function pyenv() {
  local command
  command="${1:-}"

  if [[ $# -gt 0 ]]; then
    shift
  fi

  case "${command}" in
    activate | deactivate | rehash | shell)
      eval "$(pyenv "sh-${command}" "$@")"
      ;;
    *)
      command pyenv "${command}" "$@"
      ;;
  esac
}

function main() {
  export PYENV_SHELL='bash'
  source "${PYENV_ROOT}/completions/pyenv.bash"

  _::add_to_path "${PYENV_ROOT}/bin"
  _::add_to_path "${PYENV_ROOT}/shims"

  # Enable dynamic python library.
  # some program needed this (eg: YouCompleteMe)
  export PYTHON_CONFIGURE_OPTS="--enable-shared"

  # disable prompt
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
}

main && unset -f main
