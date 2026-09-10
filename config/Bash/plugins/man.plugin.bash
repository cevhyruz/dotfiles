#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

function main() {
  if command -v nvim &>/dev/null; then
    export MANPAGER="nvim +Man!"
  else
    # don't clear the screen after quitting a manpage
    export MANPAGER='less -X'
  fi
  export MANWIDTH=96
}

function man() {
  local manual="${1-}"
  if [[ -n $manual ]]; then
    command man $manual
    return
  fi
  if _::command_exists "fzf"; then
    command man "$(apropos . | awk '{ print $1 $2 }' \
      | fzf --preview='man {}')"
  fi
}

main
