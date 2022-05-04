# vi:ft=tmux
#
# Options not related to visuals (eg: -style and format) is not included.
# As such options should be handled by a themeing script.
#
# tmux version: =1.8

# server options

set-option -g @theme default

set-option -as terminal-overrides \
',*:RGB:Smulx=\E[4::%p1%dm:Smol=\E[53m:smxx=\E[9m'\
',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

set-option -g default-terminal "tmux-256color"

set-option -s buffer-limit 25
set-option -s escape-time   0
set-option -s exit-unattached off
set-option -s set-clipboard on
set-option -s focus-event on

set-option -g renumber-windows on

# session options

set-window-option -g xterm-keys on

set-option -g assume-paste-time 1
set-option -g base-index 1
set-option -g bell-action none
set-option -g default-command "${SHELL}"
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

# In version 2.1 "mouse" replaced the previous 4 options
if-shell '[ "$(echo "$TMUX_VERSION >= 2.1" | bc)" = 1 ]' \
"set-option -g mouse "on""

# UTF8 is autodetected in 2.2 onwards,
# but will throw errors if explicitly set.
if-shell '[ "$(echo "$TMUX_VERSION < 2.2" | bc)" = 1 ]' \
"  set-window-option -g utf8        "on"; \
   set-option        -g status-utf8 "on"; \
   set-option        -g mouse-utf8  "on"; \
"

set-option -g prefix "`"
set-option -g prefix2 C-b

set-option -g repeat-time 4000
set-option -g set-titles on
set-option -g set-titles-string "#S(#W:#P)"

set-option -g status-interval 1
set-option -g status-keys vi
set-window-option -g mode-keys vi

set-option -g status-position bottom

set-option -g visual-activity off
set-option -g visual-bell off
set-option -g visual-silence off
set-option -g word-separators '-_@'
