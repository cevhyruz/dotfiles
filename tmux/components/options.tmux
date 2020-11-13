# vi:ft=tmux

%hidden TMUX_OPTS_LOADED=1

set-option -g  prefix              `
set-option -g  prefix2             C-b

set-option -g  status-keys         vi
set-option -g  mode-keys           vi

set-option -g  mouse               on
set-option -g  monitor-activity    on
set-option -g  visual-activity     off
set-option -g  bell-action         none
set-option -g  visual-bell         off

set-option -g  automatic-rename    off
set-option -g  allow-rename        off

set-option -g  pane-base-index     1
set-option -g  base-index          1
set-option -g  aggressive-resize   on
set-option -g  renumber-windows    on
set-option -g  remain-on-exit      off
set-option -g  focus-events        on

set-option -g  set-titles          on
set-option -g  set-titles-string   "#S(#W:#P)"
set-option -g  default-command     "${SHELL}"
set-option -g  default-terminal    screen-256color

set-option -g  status-interval     15
set-option -g  escape-time         0
set-option -g  display-time        5000
set-option -g  repeat-time         4000
set-option -g  display-panes-time  5000
set-option -g  message-limit       10000
set-option -g  history-limit       20000
