# vi:ft=tmux

set-option -g prefix "`"
set-option -g prefix2 C-b

bind-key -T prefix "`" send-prefix

bind-key -T prefix -N "Search for URLs in current pane" 'u' {
  copy-mode
  send-keys -X start-of-line
  send-keys -X bottom-line
  send-keys -X -F search-forward '#{_URL_PATTERN}'
}

# Open current match in BROWSER if and only if it looks like a URL
bind-key -T copy-mode-vi Enter {
  send-keys -X copy-pipe-no-clear 'sed -E "s/^git@(\\w+\\.\\w+):(.*)\$/https:\\/\\/\\1\\/\\2/" | xargs -I {} #{BROWSER} "{}"'
}

# formatted default bindings. see 'command-aliast.tmux'.
bind-key -T prefix -N "Choose a window from list" 'w'         { choose-window }
bind-key -T prefix -N "Choose a session from list" 's'        { choose-session }
bind-key -T prefix -N "Choose a paste buffer from a list" '=' { choose-buffer }

# open main menu.
bind-key -T prefix 'o' { menubar }

# toggle read-only mode.
bind-key -T prefix 'R' { switch-client -r }

# toggle synchonize pane for all pane in window.
bind-key -T prefix 'y' { set-window-option synchronize-panes }

# resize pane (left, down, up, right)
bind-key -T prefix -r '<' resize-pane -L
bind-key -T prefix -r 'J' resize-pane -D
bind-key -T prefix -r 'K' resize-pane -U
bind-key -T prefix -r '>' resize-pane -R

# copy-mode navigation.
bind-key -T copy-mode-vi 'C-h' select-pane -L;
bind-key -T copy-mode-vi 'C-j' select-pane -D;
bind-key -T copy-mode-vi 'C-k' select-pane -U;
bind-key -T copy-mode-vi 'C-l' select-pane -R;
bind-key -T copy-mode-vi 'C-\' select-pane -l;

# goto left pane
bind-key -n C-h {
  refresh-client -S
  if-shell ${IS_VIM} {
    send-keys C-h
  } {
    select-pane -L
  }
}

# goto bottom pane
bind-key -n C-j {
  refresh-client -S
  if-shell "${IS_VIM} || ${IS_FZF}" {
    send-keys C-j
  } {
    select-pane -D
  }
}

# goto top pane
bind-key -n C-k {
  refresh-client -S
  if-shell "${IS_VIM} || ${IS_FZF}" {
    send-keys C-k
  } {
    select-pane -U
  }
}

# goto right pane
bind-key -n C-l {
  refresh-client -S
  if-shell ${IS_VIM} {
    send-keys C-l
  } {
    select-pane -R
  }
}

# goto last pane
bind-key -n C-\\ {
  refresh-client -S
  if-shell ${IS_VIM} {
    send-keys C-\\
  } {
    last-pane
  }
}

# reloading
bind-key 'r' {
  refresh-client -S
  source-file "${DOT_TMUX}/tmux.conf"
  display "reloaded"
}

# split panes should start from CWD.
bind-key '%' {
  split-window -hc "#{pane_current_path}"
}

bind-key '"' split-window -vc "#{pane_current_path}"

bind-key -T copy-mode-vi 'v' {
  set-option -Ug @visual-line
  send-keys -X begin-selection
}

bind-key -T copy-mode-vi 'V' {
  set-option -g @visual-line 1
  send-keys -X select-line
}

bind-key -T copy-mode-vi 'q' {
  set-option -Ug @visual-line
  send-keys -X cancel
}

bind-key -T copy-mode-vi 'C-n' {
  send-keys -X search-again
}

bind-key -T copy-mode-vi 'C-p' {
  send-keys -X search-reverse
}

bind-key -T copy-mode-vi 'C-v' {
  send-keys -X rectangle-toggle
  send-keys -X begin-selection
}

# copy-mode scroll down by 3.
bind-key -T copy-mode-vi 'C-e' {
  send-keys -X -N 3 scroll-down
}

# copy-mode scroll up by 3.
bind-key -T copy-mode-vi 'C-y' {
  send-keys -X -N 3 scroll-up
  if-shell -F "#{selection_active}" {
    send-keys -X -N 3 cursor-down
  }
}

bind-key -T root 'C-y' {
  copy-mode -e
  if-shell -F "#{!=#{pane_current_command},nvim}" {
  } {
    send-keys -X -N 3 scroll-up
  }
}

# yanking.
bind-key -T copy-mode-vi y {
  if-shell -b "command -v xclip" {
    send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
    copy-mode -e
  } {
    send-keys -X copy-selection
  }
  if-shell -F "#{e|>:#{E:__y},2}" {
    display-message "#{E:__y} lines yanked"
  }
}
