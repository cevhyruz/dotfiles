# vim: ft=tmux fdm=marker

# status
set-option -g status                        on
set-option -g status-style                  "bg=colour234,fg=white"
set-option -g status-justify                "left"
set-option -g status-left-length            24
set-option -g status-right-length           100
set-option -g status-left-style             "bg=white,fg=color238,bold"
set-option -g status-right-style            "default"

# message styles
set-option -g message-style                 "bg=colour234,fg=cyan"
set-option -g message-command-style         "bg=colour234"

# modes
set-option -g clock-mode-style              12
set-option -g mode-style                    "bg=colour237 fg=colour250"

# window status
set-option -g window-status-current-style   "bg=colour237,fg=colour248"
set-option -g window-status-style           "bg=colour235,fg=colour248"
set-option -g window-status-separator       "│"

# choose-window, session, tree
set-option -g @tree-window-style            "fg=orange"
set-option -g @tree-window-flag-style       "fg=colour35"
set-option -g @tree-pane-title-style        "fg=white"
set-option -g @tree-session-attached-style  "fg=colour35"
set-option -g @tree-session-attached-format "(attached)"
set-option -g @tree-session-format          "(unattached)"
set-option -g @tree-session-style           "fg=colour203"
set-option -g @tree-pane-active-flag        "*"
set-option -g @tree-pane-active-flag-style  "fg=colour35"

# components
set-option -g @day-mode-style               "short"
set-option -g @month-mode-style             "long"
set-option -g @day-weekend-style            "bold,fg=colour203"
set-option -g @day-weekday-style            "default"

# live process icon colors
set-option -g @process_enabled              "bold fg=white"
set-option -g @process_disabled             "bold fg=colour239"

# status left/right
set-option -g  status-left                  " [#S] "
set-option -g  status-right                 "#{E:message}#{p4:}"
set-option -ag status-right                 "#{E:_pane_mode}#{p4:}"
set-option -ag status-right                 "#{E:wlan0_icon} "
set-option -ag status-right                 "#{E:sound} "
set-option -ag status-right                 "#{E:win_drive}     "
set-option -ag status-right                 "#{E:_date} "
set-option -ag status-right                 "#{E:_time} "

# Palette
# status formats
set-option -g window-status-format         "#{E:_window_status_format}"
set-option -g window-status-current-format "#{E:_window_status_format}"

# statusline
set-option -g status-format[0] \
"#{E:_status_left_format}#{E:_status_right_format}"\

%hidden mpris=\
"#[push-default fg=colour236]M#[fg=colour237]P#[fg=colour238]R"\
"#[fg=colour239]I#[fg=colour240]S#[fg=colour241]_"\
"#[fg=colour242]#{=40:#{s/\s/_:#{E:mpris_title}}}#[pop-default default]"\
"#[push-default default]#[fg=colour241]_#[fg=colour241]P#[fg=colour240]L"\
"#[fg=colour239]A#[fg=colour238]Y#[fg=colour237]E#[fg=colour236]R"\
"#[pop-default default]"

set-option -g status-format[1] \
"#[align=right]#{E:mpris}"\
"#{E:_window_list}"\
