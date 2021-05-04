# vi:ft=tmux

# navigate left, down, up, right
bind-key -n C-h if-shell "${IS_VIM}"              'send-keys C-h' 'select-pane -L'
bind-key -n C-j if-shell "${IS_VIM} || ${IS_FZF}" 'send-keys C-j' 'select-pane -D'
bind-key -n C-k if-shell "${IS_VIM} || ${IS_FZF}" 'send-keys C-k' 'select-pane -U'
bind-key -n C-l if-shell "${IS_VIM}"              'send-keys C-l' 'select-pane -R'

# resize pane left, down, up, right.
bind-key  -r '<' resize-pane -L
bind-key  -r 'J' resize-pane -D
bind-key  -r 'K' resize-pane -U
bind-key  -r '>' resize-pane -R

# last pane
if-shell -b '[ "$(echo "${TMUX_VERSION} < 3.0" | bc)" = 1 ]' \
"bind-key -n 'C-\\' if-shell \"$IS_VIM\" 'send-keys C-\\'   'select-pane -l'"

# easy reloading
bind-key 'r' source-file "/etc/tmux.conf" \; \
display-message "~/.tmux.conf reloaded"

# toggle synchonize pane for all pane in window.
bind-key 'y' set-window-option synchronize-panes

# split pane should start from current path of parent.
bind-key '%' split-window -h -c "#{pane_current_path}"
bind-key '"' split-window -v -c "#{pane_current_path}"

# key-tables *-edit, *-choice and *-copy have been deprecated at < 2.4
if-shell -b '[ "$(echo "$TMUX_VERSION < 2.5" | bc)" = 1 ]' \
"  bind-key -t vi-copy 'v'   begin-selection;  \
   bind-key -t vi-copy 'C-v' rectangle-toggle; \
   bind-key -t vi-copy 'V'   select-line;      \
   \
   if-shell -b 'command -v xclip' \
   \" bind-key -t vi-copy 'y' copy-pipe 'xclip -in -selection clipboard' \" \
   \
   \" bind-key -t vi-copy 'y' copy-selection \"; \
"

# the vi-copy table have been replaced by the copy-mode and copy-mode-vi tables.
if-shell -b '[ "$(echo "$TMUX_VERSION >= 2.5" | bc)" = 1 ]' \
"  bind-key -T copy-mode-vi 'v'   begin-selection;  \
   bind-key -T copy-mode-vi 'C-v' rectangle-toggle; \
   bind-key -T copy-mode-vi 'V'   select-line;      \
   \
   if-shell -b 'command -v xclip'                                    \
   \" bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel \
     'xclip -in -selection clipboard' \"                             \
   \
   \" bind-key -T copy-mode-vi 'y' copy-selection \" \
   \
   bind-key -T copy-mode-vi 'C-h' select-pane -L; \
   bind-key -T copy-mode-vi 'C-j' select-pane -D; \
   bind-key -T copy-mode-vi 'C-k' select-pane -U; \
   bind-key -T copy-mode-vi 'C-l' select-pane -R; \
   bind-key -T copy-mode-vi 'C-\' select-pane -l; \
"

# create window interactively
bind-key 'c' command-prompt  "new-window -n '%1' -c '#{pane_current_path}'"
