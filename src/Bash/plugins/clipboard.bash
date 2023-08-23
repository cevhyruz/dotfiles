#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Sane clipboard configuration

alias pbcopy="xsel --clipboard"
alias pbpaste="xsel --clipboard"

# readline functions
bind -m vi-command -x '"\C-x\C-y": printf "%s" "${READLINE_LINE-}" | pbcopy'
