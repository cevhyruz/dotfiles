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

# distinguishable cursor shapes for vi mode.
# only works on GNU readline v7.0 (bash 4.3 and up).
# @ISSUE:
# when bracketed-paste mode is enabled
# returning to vi-movement-mode will mess up the prompt
# @WORKAROUND:
# after pasting press backspace first to disable bracketed-paste
# before vi-movement-mode command or just print '\e[?2004l'.
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string \1\e[38;5;014m\e[5 q\2'
bind 'set vi-cmd-mode-string \1\e[38;5;014m\e[2 q\2'

# Completion

# append slash for completed names which are symlink to directories.
bind 'set mark-symlinked-directories on'

# case-insensitive filename matching and completion
bind 'set completion-ignore-case on'

# match all files begin with dot (.)
bind 'set match-hidden-files off'

# when complete-ignore-case is On, treats `-` and `_`
# as the same when matching and completion.
bind 'set completion-map-case on'

# be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
bind 'set skip-completed-text on'

# easier tab completion
bind 'set show-all-if-ambiguous on'
bind 'set visible-stats on'
bind 'set page-completions off'

# display common completion prefix using the value of LS_COLORS
# for custom suffix 'readline-colored-completion-prefix'
bind 'set colored-completion-prefix on'

# bash 4.3
bind 'set colored-stats on'


bind 'set enable-active-region On'
bind 'set active-region-start-color "\e[1;33m"'
bind 'set active-region-end-color "\e[1;30m"'


# display the common prefix of the list of possible completions
# (which may be empty) before cycling through the list.
bind 'set menu-complete-display-prefix on'


bind 'set print-completions-horizontally on'

