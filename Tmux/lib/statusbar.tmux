# ---------------------------------------------------------------------
#  File:        statusbar.tmux
#  Description: Reusable tmux statusbar components for easy themeing.
# ---------------------------------------------------------------------
# vi:ft=tmux

%hidden _user="#(whoami)"

%hidden _session_name=\
"#[push-default]"\
"#{session_name}"\
"#[pop-default default]"

%hidden _pwd="#{s/#{HOME}/~:#{pane_current_path}}"

%hidden _git_branch=\
"#( cd #{pane_current_path}"\
" && git symbolic-ref --quiet --short HEAD "\
"|| git rev-parse --short HEAD )"

%hidden _git_latest_commit=\
"#( cd #{pane_current_path}"\
"&& git rev-parse --short HEAD )"

%hidden _host=\
"#{=20:host} "\

# time format should always sync with clock-mode-style.
%hidden _time=\
"#{?#{==:#{clock-mode-style},24},%H,%I}:%M %p"

# Day format that changes styles on weekdays/weekends.
# user options:
#   @day-mode-style    (short|long)
#   @day-weekend-style [style]
#   @day-weekday-style [style]
%hidden _day=\
"#{?#{==:#{@day-mode-style},short},%%a,%%A}"

# Month format that changes styles.
# user options:
#   @month-mode-style (short|long)
%hidden _date=\
"#{?#{==:#{@month-mode-style},short},%b,%B}-%d"\

# Wifi connection indicator, empty if not connected.
%hidden _wifi_ssid=\
"#( iw wlan0 link | grep 'SSID' | awk '{ print $2 }')"\

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

# portable status left format.
# uses:
#   status-right-style [styles]
#   status-right       [string]
%hidden _status_right_format=\
"#[nolist align=right range=right #{E:status-right-style}]"\
"#[push-default]"\
"#{T;=/#{status-right-length}:status-right}"\
"#[pop-default]"\
"#[norange default]"

# portable status left format.
# uses:
#   status-left-style [styles]
#   status-left       [string]
%hidden _status_left_format=\
"#[align=left range=left #{E:status-left-style}]"\
"#[push-default]"\
"#{T;=/#{status-left-length}:status-left}"\
"#[pop-default]"
