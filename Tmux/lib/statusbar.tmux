# ---------------------------------------------------------------------
#  File:        statusbar.tmux
#  Description: Reusable tmux statusbar components for easy themeing.
# ---------------------------------------------------------------------
# vi:ft=tmux

# current playing song from an MPRIS supported player.
%hidden _current_playing_song=\
"#{?#{!=:#(playerctl status),Stopped},#(playerctl metadata title),}"

# current path display.
%hidden _pwd_tilde="#{s/#{HOME}/~:#{pane_current_path}}"
%hidden _pwd_home="#{s/#{HOME}/home:#{pane_current_path}}"

# Wifi connection indicator, empty if not connected.
%hidden _wifi_ssid=\
"#(iw wlan0 link | grep 'SSID' | awk '{ print $2 }')"\

# check whether the headphones is plugged in.
%hidden _has_headset=\
"#(grep -A4 -ri 'Headphone Playback Switch' /proc/asound/card*/* |"\
" grep \"Amp-Out vals.*0x00 0x0\" && echo 'connected' || echo 'disconected')"

# time format that syncs with clock-mode-style.
%hidden _time=\
"#{?#{==:#{clock-mode-style},24},%H,%I}:%M:%S %p"

# Day format that changes styles on weekdays/weekends.
# user options:
#   @day-mode-style    (short|long)
#   @day-weekend-style [style]
#   @day-weekday-style [style]
%hidden _day=\
"#{?#{==:#{@day-mode-style},short},%a,%A}"

# Month format that changes styles.
# user options:
#   @month-mode-style (short|long)
%hidden _date=\
"#{?#{==:#{@month-mode-style},short},%b,%B}-%d"\

# portable default window list.
%hidden _window_list=\
"#[norange default]"\
"#[list=on align=#{status-justify}]"\
"#[list=left-marker]<#[list=right-marker]>#[list=on]"\
"#{W:"\
"#[range=window|#{window_index} "\
"#{E:window-status-style}"\
"#{?#{&&:#{window_last_flag},"\
"#{!=:#{E:window-status-last-style},default}}, "\
"#{E:window-status-last-style},"\
"}"\
"#{?#{&&:#{window_bell_flag},"\
"#{!=:#{E:window-status-bell-style},default}}, "\
"#{E:window-status-bell-style},"\
"#{?#{&&:#{||:#{window_activity_flag},"\
"#{window_silence_flag}},"\
"#{!=:"\
"#{E:window-status-activity-style},"\
"default}}, "\
"#{E:window-status-activity-style},"\
"}"\
"}"\
"]"\
"#[push-default]"\
"#{T:window-status-format}"\
"#[pop-default]"\
"#[norange default]"\
"#{?window_end_flag,,#{window-status-separator}}"\
","\
"#[range=window|#{window_index} list=focus "\
"#{?#{!=:#{E:window-status-current-style},default},"\
"#{E:window-status-current-style},"\
"#{E:window-status-style}"\
"}"\
"#{?#{&&:#{window_last_flag},"\
"#{!=:#{E:window-status-last-style},default}}, "\
"#{E:window-status-last-style},"\
"}"\
"#{?#{&&:#{window_bell_flag},"\
"#{!=:#{E:window-status-bell-style},default}}, "\
"#{E:window-status-bell-style},"\
"#{?#{&&:#{||:#{window_activity_flag},"\
"#{window_silence_flag}},"\
"#{!=:"\
"#{E:window-status-activity-style},"\
"default}}, "\
"#{E:window-status-activity-style},"\
"}"\
"}"\
"]"\
"#[push-default]"\
"#{T:window-status-current-format}"\
"#[pop-default]"\
"#[norange list=on default]"\
"#{?window_end_flag,,#{window-status-separator}}"\
"}"

# ------------------
# portable defaults
# ------------------

# status left format.
# uses:
#   status-right-style [styles]
#   status-right       [string]
%hidden _status_right_format=\
"#[nolist align=right range=right #{E:status-right-style}]"\
"#[push-default]"\
"#{T;=/#{status-right-length}:status-right}"\
"#[pop-default]"\
"#[norange default]"

# status left format.
# uses:
#   status-left-style [styles]
#   status-left       [string]
%hidden _status_left_format=\
"#[align=left range=left #{E:status-left-style}]"\
"#[push-default]"\
"#{T;=/#{status-left-length}:status-left}"\
"#[pop-default]"

# window tree format
# uses:
#   @tree-window-style            [styles]
#   @tree-window-flag-style       [styles]
#   @tree-pane-title-style        [styles]
#   @tree-session-attached-style  [styles]
#   @tree-session-attached-format [string]
#   @tree-session-format          [string]
#   @tree-session-style           [styles]
#   @tree-pane-active-flag        [char]
#   @tree-pane-active-flag-style  [styles]
%hidden _window_tree_format=\
"#{?pane_format,"\
"#{?pane_marked,#[reverse],}"\
"#{pane_current_command}"\
"#{?pane_active,"\
"#[#{@tree-pane-active-flag-style}] #{@tree-pane-active-flag},}"\
"#{?pane_marked,M,}"\
"#{?#{&&:#{pane_title},"\
"#{!=:#{pane_title},#{host_short}}},:\"#{pane_title}\",}"\
","\
"#[#{@tree-window-style}]"\
"#{?window_format,#{window_name}"\
"#[push-default #{@tree-window-flag-style}] #{window_flags}"\
"#{?#{&&:#{==:#{window_panes},1}"\
",#{&&:#{pane_title},#{!=:#{pane_title},#{host_short}}}}, "\
"#[pop-default default]: #[#{@tree-pane-title-style}]\"#{pane_title}\",}"\
","\
"#{?session_attached,"\
"#[#{@tree-session-attached-style}]#{@tree-session-attached-format},"\
"#[#{@tree-session-style}]#{@tree-session-format}}"\
"#{?session_grouped,"\
"(group #{session_group}: #{session_group_list}),"\
"}"\
"}"\
"}"

# copy-mode selection-x,
# display selected character count.
%hidden __x=\
"#{e|+:#{?#{e|<:#{selection_end_x},#{selection_start_x}}"\
",#{e|-:#{selection_start_x},#{selection_end_x}}"\
",#{e|-:#{selection_end_x},#{selection_start_x}}"\
"}"\
",#{selection_active}}"

# copy-mode selection-y,
# display selected line count.
%hidden __y=\
"#{e|+:#{?#{e|<:#{selection_end_y},#{selection_start_y}}"\
",#{e|-:#{selection_start_y},#{selection_end_y}}"\
",#{e|-:#{selection_end_y},#{selection_start_y}}"\
"}"\
",#{selection_active}}"

# copy-mode vim-style selection,
# display selected characters/lines count.
%hidden _selection=\
"#{?#{selection_active},"\
"#{?#{e|>:#{E:__y},1}"\
",#{E:__y}"\
",#{?#{@visual-line},#{E:__y},#{E:__x}}"\
"}"\
",}"
