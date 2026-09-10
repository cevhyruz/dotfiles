#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

about-plugin 'Load pyenv, if it is installed.'
plugin-group 'wrappers'

# setup pyenv if './pyenv' directory exists.
export PYENV_ROOT="${HOME}/.pyenv"
if [[ ! -d "${PYENV_ROOT:-}" ]] \
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

  # NOTE: This should be always be above '/usr/*' in environment path,
  # so pyenv has priority over the system's python executable.
  _::add_to_path "${PYENV_ROOT}/bin"
  _::add_to_path "${PYENV_ROOT}/shims"

  # Enable dynamic python library.
  # some programs needed this (eg: YouCompleteMe)
  export PYTHON_CONFIGURE_OPTS="--enable-shared"

  # disable prompt, prompt is already handled in prompt.bash
  export PYENV_VIRTUALENV_DISABLE_PROMPT=0

export PATH="/home/cevhyruz/.pyenv/plugins/pyenv-virtualenv/shims:${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=$?
  if [ -n "${VIRTUAL_ENV-}" ]; then
    eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "$(pyenv sh-activate --quiet || true)" || true
  fi
  return $ret
};
if ! [[ "${PROMPT_COMMAND-}" =~ _pyenv_virtualenv_hook ]]; then
  PROMPT_COMMAND="_pyenv_virtualenv_hook;${PROMPT_COMMAND-}"
fi


}

main
