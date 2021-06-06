#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

# Pyenv plugin for Bash

PYENV_ROOT="${HOME}/.pyenv"

if _::add_to_path "${PYENV_ROOT}/bin"; then
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
  fi
  # Build with dynamic python library enabled.
  # some program needed this (eg: YouCompleteMe)
  export PYTHON_CONFIGURE_OPTS="--enable-shared"
fi
