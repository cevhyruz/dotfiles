#-----------------------------------
#        Colors and Styles         |
#-----------------------------------

# Color reference from https://jonasjacek.github.io/colors/.

# Color Variables. - - - - - - - - - - - - - - - - - - - - - - - - - -
status_bg=colour235
status_fg=colour245
status_bluegreen=colour30

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
# Adjust window's index number if changed.
set-option -g renumber-windows on

# Remove separator between window names.
setw -g window-status-separator ''

#  Modes. - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
setw -g clock-mode-colour $status_bg
setw -g mode-attr bold
setw -g mode-fg colour13
setw -g mode-bg colour134

# Panes. - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set -g pane-border-bg $status_bg
set -g pane-border-fg $status_fg
set -g pane-active-border-bg $status_bg
set -g pane-active-border-fg $status_fg

# Statusbar. - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set -g status-position bottom
set -g status-justify centre
set -g status-bg $status_bg
set -g status-fg white
set -g status-attr bold

# Status Left. - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set -g status-left-bg $status_bg
set -g status-left-fg $status_fg
set -g status-left  \
" ☰#[bg=colour236,fg=colour30] #(tmux list-session | wc -l) "\
"#[bg=colour23,fg=colour236]"\
"#[bg=colour23,fg=colour234] #S [#(tmux list-windows | wc -l)] "\
"#[bg=colour234,fg=colour23]"\
"#[bg=colour235,fg=colour234]  "\

# Status Right. - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set -g status-right-bg $status_bg
set -g status-right-fg colour239
set -g status-right \
"#[fg=colour235]"\
"#[bg=colour235,fg=colour245, none] ♬ Nakapagtataka - Sponge Cola.. "\
"#[fg=colour234,bg=$status_bg]"\
"#[fg=colour23,bg=colour234]"\
"#[fg=colour233,bg=colour23,bold] %m:%d "\
"#[fg=colour233,bg=colour29,bold] #H "
 
#   Status Right =    %d/%m  %H:%M:%S
set -g status-right-length 56
set -g status-left-length 30

# Current active window. - - - - - - - - - - - - - - - - - - - - - - -
setw -g window-status-current-fg colour30
setw -g window-status-current-bg $status_bg
setw -g window-status-current-attr bold
setw -g window-status-current-format \
"#[fg=colour235,bg=colour235]#[fg=colour235,bg=colour235]"\
"#[fg=colour30] #I "\
"#[fg=colour130]#W "

# Normal window. - - - - - - - - - - - - - - - - - - - - - - - - - - -
setw -g window-status-fg colour30
setw -g window-status-bg $status_bg
setw -g window-status-attr none

# Normal window format.
setw -g window-status-format \
"#[fg=colour235,bg=colour235]"\
"#[bg=colour235,fg=colour30,bold] #I "\
"#[fg=colour246]#W "

# Messages and Command mode. - - - - - - - - - - - - - - - - - - - - -
set -g message-attr bold
set -g message-fg colour250
set -g message-bg colour23
