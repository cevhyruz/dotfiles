# vi:ft=tmux fdm=marker
# ---------------------------------------------------------------------------
# File:        components.tmux
# Description: portable status line components useful for themeing
# ---------------------------------------------------------------------------

# Root Table {{{1

bind-key -N "Navigate to the pane above (aliased: up) "       -n 'C-k' up
bind-key -N "Navigate to the pane below (aliased: down)"      -n 'C-j' down
bind-key -N "Navigate to the left pane (aliased: left)"       -n 'C-h' left
bind-key -N "Navigate to the right pane (aliased: right)"     -n 'C-l' right
bind-key -N "Go to the last visited pane (aliased: lastpane)" -n 'C-\' lastpane

# Prefix Table {{{1

bind -N "Reload tmux configuration file (aliased: reload)"   'r' reload
bind -N "Split window vertically (aliased: vsplit)"          '%' vsplit

bind -N "Adjust pane size by 1 column left (repeatable)"  -r 'H' _resize-pane-left
bind -N "Adjust pane size by 1 column down (repeatable)"  -r 'J' _resize-pane-down
bind -N "Adjust pane size by 1 column up (repeatable)"    -r 'K' _resize-pane-up
bind -N "Adjust pane size by 1 column right (repeatable)" -r 'L' _resize-pane-right

bind -N "Adjust pane size by 2 column left (repeatable)"  -r '<' resize-pane -L 2
bind -N "Adjust pane size by 2 column right (repeatable)" -r '>' resize-pane -R 2

bind -N "Start Visual mode" 'v' copy-mode
