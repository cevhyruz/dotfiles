#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Sane clipboard configuration

__util::command_exists "xsel" || return 0

alias pbcopy="xsel --clipboard"
alias pbpaste="xsel --clipboard"

# readline functions
bind -m vi-command -x '"\C-x\C-y": printf "%s" "${READLINE_LINE-}" | pbcopy'
