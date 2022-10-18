# vi:ft=tmux fdm=marker

set-hook -g before-list-keys {
  display "should have fired a long time ago"
}

set-hook -g after-list-keys {
  resize-pane -Z
}
