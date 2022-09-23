#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

function main() {
  # @note: exporting LESS will pagerize some git commands and aliases,
  # set "core.pager" and/or "pager.<cmd/alias>" to false to avoid this.
  # shellcheck disable=SC2154
  export LESS_TERMCAP_md="\e[33m" # higlight section titles in manpages
  export LESS="--quiet --raw-control-chars --ignore-case"
}

main
