# vim: ft=tmux fdm=marker

# status
set -g status                        on
set -g status-position               "bottom"
set -g status-style                  "bg=colour234,fg=white"
set -g status-justify                "left"
set -g status-left-length            24
set -g status-right-length           100
set -g status-left-style             "bg=white,fg=color238,bold"
set -g status-right-style            "fg=colour248"

# message stylej
set -g message-style                 "bg=colour234,fg=cyan"
set -g message-command-style         "bg=colour234"

# modes
set -g clock-mode-style              12
set -g mode-style                    "bg=colour237 fg=colour250"

# window status
set -g window-status-current-style   "fg=colour248"
set -g window-status-style           "fg=colour242"
set -g window-status-separator       "#[push-default fg=colour239]│"

# choose-window, session, tree
set -g @tree-window-style            "fg=orange"
set -g @tree-window-flag-style       "fg=colour35"
set -g @tree-pane-title-style        "fg=white"
set -g @tree-session-attached-style  "fg=colour35"
set -g @tree-session-attached-format "(attached)"
set -g @tree-session-format          "(unattached)"
set -g @tree-session-style           "fg=colour203"
set -g @tree-pane-active-flag        "*"
set -g @tree-pane-active-flag-style  "fg=colour35"

# components
set -g @day-mode-style               "long"
set -g @day-weekend-style            "bold,fg=colour203"
set -g @day-weekday-style            "bold,fg=red,bg=white"

set -g @month-mode-style             "short"


# indicators (WLAN) false
set -g @ind-wlan-0-char  "Not connected"
set -g @ind-wlan-0-icon  "#{@fa-wifi}"
set -g @ind-wlan-0-style "bold,fg=colour239"

# indicators (WLAN) true
set -g @ind-wlan-1-char  "Connected "
set -g @ind-wlan-1-icon  "#{@fa-wifi}"
set -g @ind-wlan-1-style "fg=white"

set -g @status-message-style         "fg=green"
set -g @status-message-timeout        5

# status left/right
set -g  status-left                  " #S "

set -g  status-right                 "#{E:message}  "
set -ag status-right                 "#{E:_pane_mode}   "
set -ag status-right                 "#{E:ind_wlan} "
set -ag status-right                 "#{E:sound}"
set -ag status-right                 "#{E:win_drive}   "
set -ag status-right                 "#{user}@#{host_short}   "
set -ag status-right                 "#{E:_date}   "
set -ag status-right                 "#{E:_time} "

# Palette
# status formats
set -g window-status-format         "#{E:_window_status_format}"
set -g window-status-current-format "#{E:_window_status_format}"

# statusline
set -g status-format[0] \
"#{E:_status_left_format}"\
"#{E:_window_list}"\
"#{E:_status_right_format}"\

%hidden mpris=\
"#[push-default fg=colour236]M#[fg=colour237]P#[fg=colour238]R"\
"#[fg=colour239]I#[fg=colour240]S#[fg=colour241]_"\
"#[fg=colour242]#{=40:#{s/\s/_:#{E:mpris_title}}}#[pop-default default]"\
"#[push-default default]#[fg=colour241]_#[fg=colour241]P#[fg=colour240]L"\
"#[fg=colour239]A#[fg=colour238]Y#[fg=colour237]E#[fg=colour236]R"\
"#[pop-default default]"

set -g status-format[1] \
"#[push-default fg=colour242]#{E:current_path}: #{E:_permission}#[align=right]#{E:mpris}"\
