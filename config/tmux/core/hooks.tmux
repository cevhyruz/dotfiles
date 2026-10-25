# vi:ft=tmux fdm=marker

# set-hook -g before-list-keys {
#   display "should have fired a long time ago"
# }

set-hook -g after-list-keys {
  resize-pane -Z
}

# When pane becomes active
set-hook -g pane-focus-in   {
  setenv -g TMUX_PANE_ACTIVE 1
}

# When pane becomes inactive
set-hook -g pane-focus-out {
  setenv -g TMUX_PANE_ACTIVE 0
}

# Update the terminal's idea of the cwd when the active pane changes
# needs the osc7.sh script and tmux option allow-passthrough on.
set-hook -ag after-select-pane      { __vte_osc7 }
set-hook -ag after-select-window    { __vte_osc7 }
set-hook -ag client-session-changed { __vte_osc7 }
