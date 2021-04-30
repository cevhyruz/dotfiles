# vi:ft=tmux
#
# Options not related to visuals (eg: -style and format) is not included.
# As such options should be handled by a themeing script.
#
# tmux version: =1.8

# server options

set-option -s buffer-limit 25
set-option -s escape-time   0
set-option -s exit-unattached off
set-option -s quiet off
set-option -s set-clipboard on
set-option -s focus-event on

# session options

set-option -g default-terminal "screen-256color"

set-window-option -g xterm-keys on

set-option -g repeat-time 600
set-option -g assume-paste-time 1
set-option -g base-index 1
set-option -g bell-action none
set-option -g bell-on-alert off
set-option -g default-command "${SHELL}"
set-option -g default-path ""
set-option -g default-shell "${SHELL}"
set-option -g display-time  5000
set-option -g history-limit 20000
set-option -g message-limit 10000

# Mouse Support
if-shell '[ $(echo "$TMUX_VERSION < 2.1" | bc) = 1 ]' \
"  set-window-option -g mode-mouse          "on"; \
   set-option        -g mouse-resize-pane   "on"; \
   set-option        -g mouse-select-window "on"; \
   set-option        -g mouse-select-pane   "on"; \
"

## In version 2.1 "mouse" replaced the previous 4 options
if-shell '[[ "$(echo "$TMUX_VERSION >= 2.1" | bc)" = 1 ]]' \
"set-option -g mouse "on""

# UTF8 is autodetected in 2.2 onwards,
# but will throw errors if explicitly set.
if-shell '[ "$(echo "$TMUX_VERSION < 2.2" | bc)" = 1 ]' \
"  set-window-option -g utf8        "on"; \
   set-option        -g status-utf8 "on"; \
   set-option        -g mouse-utf8  "on"; \
"

set-option -g prefix '`'
set-option -g prefix2 C-b

set-option -g repeat-time 4000
set-option -g set-remain-on-exit off
set-option -g set-titles on
set-option -g set-titles-string "#S(#W:#P)"
set-option -g status on

set-option -g status-interval 10
set-option -g status-justify left
set-option -g status-keys vi
set-window-option -g mode-keys vi

set-option -g status-position bottom

set-option -g visual-activity off
set-option -g visual-bell off
set-option -g visual-content off
set-option -g visual-silence off
set-option -g word-separators '-_@'
