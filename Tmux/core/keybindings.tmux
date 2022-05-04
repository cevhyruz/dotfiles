# vi:ft=tmux

bind-key -T prefix -N "Choose a window from list" 'w' {
  choose-window -Z
}

bind-key -T prefix -N "Choose a session from list" 's' {
  choose-session -Z
}

# create window interactively
bind-key 'c' command-prompt -p "[#{b:pane_current_path}]:"

bind-key -T prefix 'o' {
  menubar
}

bind-key -T prefix 'R' { switch-client -r }

# toggle synchonize pane for all pane in window.
bind-key -T prefix 'y' { set-window-option synchronize-panes }

# resize pane (left, down, up, right)
bind-key  -r '<' resize-pane -L
bind-key  -r 'J' resize-pane -D
bind-key  -r 'K' resize-pane -U
bind-key  -r '>' resize-pane -R

# navigator
bind-key -n C-h {
  refresh-client -S
  if-shell ${IS_VIM} { send-keys C-h } { select-pane -L }
}

bind-key -n C-j {
  refresh-client -S
  if-shell "${IS_VIM} || ${IS_FZF}"  { send-keys C-j } { select-pane -D }
}

bind-key -n C-k {
  refresh-client -S
  if-shell "${IS_VIM} || ${IS_FZF}" { send-keys C-k } { select-pane -U }
}

bind-key -n C-l {
  refresh-client -S
  if-shell ${IS_VIM} { send-keys C-l } { select-pane -R }
}

bind-key -n C-\\ {
  refresh-client -S
  if-shell ${IS_VIM} { send-keys C-\\ } { select-pane -l }
}

# reloading
bind-key 'r' {
  refresh-client -S
  source-file ${DOT_TMUX}/tmux.conf
}

# split panes should start from CWD.
bind-key '%' split-window -h -c "#{pane_current_path}"
bind-key '"' split-window -v -c "#{pane_current_path}"

bind-key -T copy-mode-vi 'v'  send-keys -X begin-selection
bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle
bind-key -T copy-mode-vi 'V' send-keys -X select-line

if-shell -b "command -v xclip" {
  bind-key -T copy-mode-vi 'y' {
    send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
  }
} {
  bind-key -T copy-mode-vi 'y' send-keys -X copy-selection
}

bind-key -T copy-mode-vi C-h select-pane -L;
bind-key -T copy-mode-vi C-j select-pane -D;
bind-key -T copy-mode-vi C-k select-pane -U;
bind-key -T copy-mode-vi C-l select-pane -R;
bind-key -T copy-mode-vi  C-\\ select-pane -l;
