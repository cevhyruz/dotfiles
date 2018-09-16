#-----------------------------------
#        Colors and Styles         |
#-----------------------------------

# Color reference from https://jonasjacek.github.io/colors/.

# Color Variables.
status_bg=colour235
status_fg=colour245
song_playing='/home/devs/Projects/dotfiles/bin/current_playing_song'
status_bg_backdrop=colour234
status_bluegreen=colour30

# Adjust window's index number if changed.
set-option -g renumber-windows on

# Remove separator between window names.
setw -g window-status-separator ''

# Modes.
setw -g clock-mode-colour $status_fg
setw -g mode-attr bold
setw -g mode-fg colour13
setw -g mode-bg colour134


# Panes.
set -g pane-border-bg $status_bg
set -g pane-border-fg $status_fg
set -g pane-active-border-bg $status_bg
set -g pane-active-border-fg $status_fg

# Statusbar.
set -g status-position bottom
set -g status-justify left
set -g status-bg $status_bg
set -g status-fg white
set -g status-attr bold

# Status right.
set -g status-right-length 70
set -g status-right-bg $status_bg
set -g status-right-fg colour239
set -g status-right \
"#[fg=colour235]"\
"#[bg=colour235, fg=colour245, none] ♬ #($song_playing).. "\
"#[fg=colour234, bg=$status_bg]"\
"#[fg=colour23, bg=colour234]"\
"#[fg=colour233, bg=colour23] %h %d,"\
"#[fg=colour109, bg=colour23]%l:%M %p "\
"#[fg=colour233, bg=colour29,bold] #H "

# Status Left.
set -g status-left-length 60
set -g status-left-bg $status_bg
set -g status-left-fg $status_fg
set -g status-left  \
" ☰#[bg=colour236, fg=colour30] #(tmux list-session | wc -l) "\
"#[bg=colour23, fg=colour236]"\
"#[bg=colour23, fg=colour234] #S [#(tmux list-windows | wc -l)] "\
"#[bg=$status_bg_backdrop, fg=colour23]"\
"#[bg=$status_bg, fg=colour234] "\
"#[bg=$status_bg, fg=colour23, none]0↓ 8↑"\
"#[bg=$status_bg, fg=colour237] "

# Current active window.
setw -g window-status-current-fg colour30
setw -g window-status-current-bg $status_bg
setw -g window-status-current-attr bold
setw -g window-status-current-format ' #I #[fg=colour137]#W '

# Normal window.
setw -g window-status-fg colour30
setw -g window-status-bg colour235
setw -g window-status-attr bold
setw -g window-status-format ' #I #[fg=colour246]#W '

# Messages and Command mode.
set -g message-attr bold
set -g message-fg colour250
set -g message-bg colour23