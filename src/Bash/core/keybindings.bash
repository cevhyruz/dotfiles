#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2016
# vim: ft=sh fdm=marker ts=2 sw=2 et

# exit vi-insert editing mode
bind -m vi-insert '"kj": vi-movement-mode'

# history navigation
bind -m vi-command '"K": history-search-backward'
bind -m vi-command '"J": history-search-forward'

# terminate current bash session
bind -m vi-command '";q": "dd\C-d"'

bind -m vi-command '"qa": start-kbd-macro'
bind -m vi-command '"q":  end-kbd-macro'
bind -m vi-command '".": call-last-kbd-macro'
bind -m vi-command '"z": print-last-kbd-macro'

# easier tab completion
bind 'set show-all-if-ambiguous on'
bind 'set visible-stats on'
bind 'set page-completions off'
