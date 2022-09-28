# vim: ft=tmux fdm=marker

# choose-window, session, tree
set-option -g @tree-window-style            'fg=orange'
set-option -g @tree-window-flag-style       'fg=colour35'
set-option -g @tree-pane-title-style        'fg=white'
set-option -g @tree-session-attached-style  'fg=colour35'
set-option -g @tree-session-attached-format '(attached)'
set-option -g @tree-session-format          '(unattached)'
set-option -g @tree-session-style           'fg=colour203'
set-option -g @tree-pane-active-flag        '*'
set-option -g @tree-pane-active-flag-style  'fg=colour35'

set-option -g message-style         "bg=colour234,fg=cyan"
set-option -g message-command-style "bg=colour234"

set-option -g status-style "bg=colour235,fg=colour247"

# component styles
set-option -g @day-mode-style    "short"
set-option -g @month-mode-style  "long"
set-option -g @day-weekend-style "bold,fg=colour203"
set-option -g @day-weekday-style "default"

set-option -g clock-mode-style   12

set-option -g mode-style 'bg=colour237 fg=colour250'

# window status
set-option -g status-justify              "left"
set-option -g window-status-current-style "bg=colour239,fg=colour232"
set-option -g window-status-style         "bg=colour236,fg=colour248"
set-option -g window-status-separator     ""

set-option -g window-status-format \
"#[push-default fg=colour235]"\
"#[fg=cyan]  #I"\
"#[pop-default default]: #W #{?#{==:#F,}, ,#F}  "\
"#[bg=colour235 fg=colour236]"

set-option -g window-status-current-format \
"#[push-default bg=colour239 fg=colour235]"\
"#[fg=colour232]  #I"\
"#[pop-default default]: #W #{?#{==:#F,}, ,#F}  "\
"#[fg=colour239 bg=colour235]"

# status length
set-option -g status-left-length  40
set-option -g status-right-length 100

# status-style
set-option -g status-right-style "default"
set-option -g status-left-style "default"

# live process icon colors
set-option -g @process_enabled  "bold fg=colour231"
set-option -g @process_disabled "bold fg=colour234"


set-option -g status-left \
"[#S] #{E:current_path}"\

# status left/right
set-option -g status-right \
"#{E:_selection}   "\
"#{E:wlan0_icon} #{E:sound} #{E:win_drive}  "\
"#{E:_date} #{E:_time}"

set-option -g status-format[0] \
"#{?client_readonly,#[fg=colour203]#{E:@fa-lock} "\
"readonly mode. Press <#{prefix}> + R to toggle.,"\
"#{E:_status_left_format}"\
"#[fill=#{E:_status_client_mode_fill}]"\
"#{E:_status_right_format}"\
"}"

%hidden mpris=\
"#[push-default fg=colour236]M#[fg=colour237]P#[fg=colour238]R"\
"#[fg=colour239]I#[fg=colour240]S#[fg=colour241]_"\
"#[fg=colour242]#{=40:#{s/\s/_:#{E:mpris_title}}}#[pop-default default]"\
"#[push-default default]#[fg=colour241]_#[fg=colour241]P#[fg=colour240]L"\
"#[fg=colour239]A#[fg=colour238]Y#[fg=colour237]E#[fg=colour236]R"\
"#[pop-default default]"

set-option -g status-format[1] \
"#[align=right]#{E:mpris}"\
"#{E:_window_list}"
