# vi:ft=tmux

%hidden TMUX_CMD_LOADED=1

run-shell -F "${TMUX_OPTS_LOADED}" {
   source-file -q "${HOME}/Projects/dotfiles/tmux/components/options.tmux"
}

# navigation {{{2

set-option -s command-alias[6] down='
if-shell "$is_vim || $is_fzf" {
  if-shell -f "#{m/r:(copy|view)-mode,#{pane_mode}}" {
    select-pane -d
  } {
    send-keys c-j
  }
} { select-pane -d }'

set-option -g command-alias[7] up='
if-shell "$is_vim || $is_fzf" {
   if-shell -f "#{m/r:(copy|view)-mode,#{pane_mode}}" {
       select-pane -u
   } {
    send-keys c-k
   }
} { select-pane -u }'

set-option -s command-alias[8] right='
if-shell "$is_vim" {
  if-shell -f "#{m/r:(copy|view)-mode,#{pane_mode}}" {
    select-pane -r
  } {
    send-keys c-l
  }
} { select-pane -r }'

set-option -s command-alias[9] left='
if-shell "$is_vim" {
  if-shell -f "#{m/r:(copy|view)-mode,#{pane_mode}}" {
    select-pane -l
  } {
    send-keys c-h
  }
} { select-pane -l }'

set-option -s command-alias[10] lastpane='
if-shell "$is_vim" {
  send-keys c-\\
} { last-pane } '

# resizing {{{1

set-option -s command-alias[11]  _resize-pane-down='resize-pane -d 1'
set-option -s command-alias[12]    _resize-pane-up='resize-pane -u 1'
set-option -s command-alias[13] _resize-pane-right='resize-pane -r 1'
set-option -s command-alias[14]  _resize-pane-left='resize-pane -l 1'

set-option -s command-alias[32] term='
command-prompt -p "[${shell}]" {
  display-popup -keer "%1"
}'

set-option -s command-alias[100] version='display "#{version}"'

# Miscellaneous

set-option -s command-alias[20] reload='
source-file -q "/etc/tmux.conf";
display-message " Config file reloaded";';

set-option -s command-alias[24] vsplit='split-window -h'

# Keybindings

