#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2016
# vim: ft=sh fdm=marker ts=2 sw=2 et

bind -m vi-insert '"kj": vi-movement-mode' # ESC

bind -m vi-command '"K": history-search-backward'
bind -m vi-command '"J": history-search-forward'

# terminate current session
bind -m vi-command '";q": "dd\C-d"'

# macro
bind -m vi-command '"qa": start-kbd-macro'
bind -m vi-command '"q":  end-kbd-macro'
bind -m vi-command '".": call-last-kbd-macro'
bind -m vi-command '"z": print-last-kbd-macro'
