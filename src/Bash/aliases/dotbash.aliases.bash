#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Alias exclusively for use inside this dotfiles's Bash.

[[ -z $DOT_BASH ]] && return 0

alias runtime='printf "%s\n" "${runtime[@]}"'
alias scriptnames='printf "%s\n" "${scriptnames[@]}"'
