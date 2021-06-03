#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

function _set_term() {
  # only set $TERM when we're not inside tmux
  if ! [[ "${TERM}" =~ ^screen ]] || [[ "${TERM}" =~ ^tmux ]]; then
    if [[ "${COLORTERM}" = gnome-* && "${TERM}" = xterm ]] &&
      infocmp gnome-256color >/dev/null 2>&1; then
      export TERM='gnome-256color'
    elif infocmp xterm-256color >/dev/null 2>&1; then
      export TERM='xterm-256color'
    fi
  fi
}

_set_term
