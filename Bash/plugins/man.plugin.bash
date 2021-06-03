#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

function main() {
  command -v nvim &>/dev/null || {
    export MANPAGER='less -X' # don't clear the screen after quitting a manpage
    return
  }
  export MANWIDTH=96
  # set neovim as manpager
  export MANPAGER="nvim -c ':set ft=man'"
  # [?] for faster manpager without plugins uncomment the line below.
  # export MANPAGER="nvim --noplugin -c ':set ft=man'";
}

main
