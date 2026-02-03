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
