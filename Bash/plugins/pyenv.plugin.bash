#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Pyenv plugin for Bash

export PYENV_ROOT="${HOME}/.pyenv"

if [[ ! -d "${PYENV_ROOT}" ]] \
  && [[ ! -x "${PYENV_ROOT}/bin/pyenv" ]]; then
  unset -v PYENV_ROOT
  return 0
fi

_::add_to_path "${PYENV_ROOT}/bin"
_::add_to_path "${PYENV_ROOT}/shims"

# Enable dynamic python library.
# some program needed this (eg: YouCompleteMe)
export PYTHON_CONFIGURE_OPTS="--enable-shared"

# disable prompt
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

eval "$(pyenv init - bash)"
