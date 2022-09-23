# vi:ft=tmux

# Mouse keybinding events:
# =============================================================================

# mouse events

# [ / ] 1.) double click select word.
# [ / ] 2.) tripple click select line.
# [ / ] 2.) left click select cursor position .
# [ / ] 4.) right-click select position and open a menu.
# [ / ] 5.) left-click + drag starts selection but won't cancel on click-up
# [ x ] 6.) mouse scroll should not drag a selection.
# [ x ] 7.) mouse scroll-down to bottom should not cancel if there is a selection
# [ x ] 8.) mouse scrol-down to bottom should not cancel if there is

# mouse scrollup /
bind-key -T root WheelUpPane {
  select-pane -t=
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send-keys -M
  } {
    copy-mode -e
    send-keys -X -N 3 scroll-up
  }
}
bind-key -T copy-mode-vi WheelUpPane {
  select-pane -t=
  send-keys -X -N 5 scroll-up
}

# Right click
bind-key -T root MouseDown3Pane {
  select-pane -t=
  context-menu-mouse
}
bind-key -T copy-mode-vi MouseDown3Pane {
  select-pane -t=
    display "#{context}"
  context-menu-mouse
}

# Left click
bind-key -T copy-mode-vi MouseDown1Pane {
  select-pane -t=
  send-keys -X clear-selection
}
bind-key -T root MouseDown1Pane {
  select-pane -t=
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send-keys -M
  } {
  }
}



# disable MouseDragEnd1Pane binding which cancels selection.
unbind-key -T copy-mode-vi MouseDragEnd1Pane

# mouse drag
bind-key -T copy-mode-vi MouseDrag1Pane {
  select-pane -t=
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
      copy-mode -M
    send-keys -X begin-selection
  } {
    copy-mode -eM
  }
}

# mouse drag
bind-key -T root MouseDrag1Pane {
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send-keys -M
  } {
    copy-mode -eM
  }
}

# 1.) double click to select word.
# @fixme:
# SecondClick1Pane will clear while,
# DoubleClick1Pane is slow but wont clear.
# combining the two seems to fix this for now.
bind-key -T root SecondClick1Pane {
  select-pane -t=
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send-keys -M
  } {
    copy-mode -e
    send-keys -X select-word
  }
}
bind-key -T copy-mode-vi SecondClick1Pane {
  select-pane -t=
  send-keys -X select-word
}
bind-key -T root DoubleClick1Pane {
  select-pane -t=
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send-keys -M
  } {
    copy-mode -e
    send-keys -X select-word
  }
}
bind-key -T copy-mode-vi DoubleClick1Pane {
  select-pane -t=
  send-keys -X select-word
}

# triple click select line.
bind-key -T copy-mode-vi TripleClick1Pane  {
  select-pane -t=
  send-keys -X select-line
}
bind-key -T root  TripleClick1Pane {
 select-pane -t=
 if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
   send-keys -M
 } {
   copy-mode -H
   send-keys -X select-line
 }
}
