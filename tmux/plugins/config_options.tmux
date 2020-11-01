# vi:ft=tmux fdm=marker
# ---------------------------------------------------------------------------
# File:        setup.tmux
# Description: setup necesarry things for tmux accordingly
# --------------------------------------------------------------------------

# Initial Defaults

set-option -g  @theme              "powerline"
set-option -g  @extra-config       "${TMUX_LOCALRC}/tmuxrc.local"
set-option -g  @default-dir        "${DOTFILES_DIR}"
set-option -g  @scroll-column      5

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
set-option -g  default-terminal    tmux-256color

set-option -g  status-interval     15
set-option -g  escape-time         0
set-option -g  display-time        5000
set-option -g  repeat-time         4000
set-option -g  display-panes-time  5000
set-option -g  message-limit       10000
set-option -g  history-limit       20000


# Navigation {{{1

set-option -s command-alias[6] down='
if-shell "$IS_VIM || $IS_FZF" {
  if-shell -F "#{m/r:(copy|view)-mode,#{pane_mode}}" {
    select-pane -D
  } {
    send-keys C-j
  }
} { select-pane -D }'

set-option -g command-alias[7] up='
if-shell "$IS_VIM || $IS_FZF" {
   if-shell -F "#{m/r:(copy|view)-mode,#{pane_mode}}" {
       select-pane -U
   } {
    send-keys C-k
   }
} { select-pane -U }'

set-option -s command-alias[8] right='
if-shell "$IS_VIM" {
  if-shell -F "#{m/r:(copy|view)-mode,#{pane_mode}}" {
    select-pane -R
  } {
    send-keys C-l
  }
} { select-pane -R }'

set-option -s command-alias[9] left='
if-shell "$IS_VIM" {
  if-shell -F "#{m/r:(copy|view)-mode,#{pane_mode}}" {
    select-pane -L
  } {
    send-keys C-h
  }
} { select-pane -L }'

set-option -s command-alias[10] lastpane='
if-shell "$IS_VIM" {
  send-keys C-\\
} { last-pane } '


# Resizing {{{1

set-option -s command-alias[11]  _resize-pane-down='resize-pane -D 1'
set-option -s command-alias[12]    _resize-pane-up='resize-pane -U 1'
set-option -s command-alias[13] _resize-pane-right='resize-pane -R 1'
set-option -s command-alias[14]  _resize-pane-left='resize-pane -L 1'

set-option -s command-alias[32] term='
command-prompt -p "[${SHELL}]" {
  #  FIXME: disable ansi (git status)
  run-shell -b {
    bash -c "%% || tmux display -p $?"
  }
}'


set-option -s command-alias[100] version='display "#{version}"'

# Miscellaneous

set-option -s command-alias[20] reload='
source-file -q "/etc/tmux.conf";
display-message " Config file reloaded";';

set-option -s command-alias[24] vsplit='split-window -h'
