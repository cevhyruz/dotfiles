# ---------------------------------------------------------------------------
# File:        powerline-format.tmux
# Description: define how the tmux statusbar looks
# ---------------------------------------------------------------------------
# vi:ft=tmux

set -g status-left \
"#[bold]#{=4:client_key_table} #[fg=$powerline_left_status, bg=$powerline_bg_main]"\
" #[bold]#{session_name} "

set -g @heh "#[bg=$powerline_bg_main, fg=$powerline_left_status$]#[default]"
#set -g status-right \
"#{E:@heh} %Y-%m-%d #{E:@heh} %I:%M"

set -g @hah "#[fg=$powerline_bg_main, bg=$powerline_current]#[default]"
set -g @hoh "#[bg=$powerline_status, fg=$powerline_bg_main]#[default]"

set -g pane-border-format   "─"

set -g @fmt "#[bold, fg=colour232]#[default]"
set -g window-status-format \
"#{E:@hoh} #[bold]#{window_index} #{E:@fmt} #{window_name} "\
"#{?window_flags,#[bold fg=colour245]#{window_flags} #[reverse]#{E:@hoh},  #[reverse bold]#{E:@hoh}}"

set -g window-status-current-format \
"#{E:@hah} #[bold]#{window_index} #{E:@fmt} #{window_name} "\
"#{?window_flags,#[bold fg=colour245]#{window_flags} #[reverse]#{E:@hah},  #[reverse]#{E:@hah}}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set-option -g status-right "bg=$powerline_bg_main"
set-option -g status-format[0] \
"#[fill=$powerline_bg_main]#{E:@status-left-format}"\
"#{E:@window_list}#{status-right}"

#set-option -g status-format[0] \
#"#S: #{E:@window_list}"\

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#set-option -g status-format[0]  ""
#set-option -g status-format[2]  ""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#set-option -g status-format[2] \
#"#{E:@status-left-format}"\
#"#{E:@status-right-format}"

