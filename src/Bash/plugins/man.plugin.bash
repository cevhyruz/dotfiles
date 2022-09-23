#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# export MANPAGER='less -X' # don't clear the screen after quitting a manpage
# MANPAGER="vim -c 'set ft=man' -"
# return
function main() {
  command -v nvim &>/dev/null || {
    export MANPAGER='less -X' # don't clear the screen after quitting a manpage
    return
  }
  export MANPAGER="nvim +Man!"
  export MANWIDTH=96
}

main
