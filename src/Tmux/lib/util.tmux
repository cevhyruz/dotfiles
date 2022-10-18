# vi:ft=tmux

# process checks

# process checks
# @FIXME: Use regular expression comparison here (fnmatch(3)).
%hidden IS_VIM="ps -o state= -o comm= -t #{pane_tty} | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
%hidden IS_BASH="ps -o comm= -t #{pane_tty} | grep -q bash"
%hidden IS_TIG="ps -o comm= -t #{pane_tty} | grep -q tig"

%hidden IS_FZF="#{==:#{pane_current_command},fzf}"
%hidden IS_VIM="#{m:*vim,#{pane_current_command}}"
%hidden IS_SHELL="#{m:*sh,#{pane_current_command}}"
%hidden IS_TIG="#{==:#{pane_current_command},tig}"

%hidden _IS_FZF="ps -o comm= -t #{pane_tty} | grep -q fzf"
%hidden _IS_VIM="ps -o state= -o comm= -t #{pane_tty} | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

# set padding depending on '@menu-item-padding' value.
# @FIXME: expand this without using 'set-option'
# user options:
#   @menu-item-padding [number]
set-option -gF @_padding "##{#{p#{@menu-item-padding}:}#}"
%hidden pad="#{E:@_padding}"

# current path directory permission.
%hidden _permission=\
"#(ls -ld #{pane_current_path} | awk '{printf \"%%s:%%s:%%s\", $3,$4,$1}')"

# pane current path.
%hidden current_path="#{s/#{HOME}/~:#{pane_current_path}}"

# show playing song.
%hidden mpris_title="#(playerctl metadata title)"

# wlan0 ssid name.
%hidden wlan0_ssid="#(iw wlan0 link | grep 'SSID' | awk '{ print $2 }')"

# time format that syncs with clock-mode-style.
# options:
#   clock-mode-style [styles]
%hidden _time="#{?#{==:#{clock-mode-style},24},%H,%I}:%M:%S %p"

# Day format that changes styles on weekdays/weekends.
# user options:
#   @day-mode-style    (short|long)
#   @day-weekend-style [style]
#   @day-weekday-style [style]
%hidden _day="#{?#{==:#{@day-mode-style},short},%a,%A}"

# Month format that changes styles.
# user options:
#   @month-mode-style (short|long)
%hidden _date="#{?#{==:#{@month-mode-style},short},%b,%B}-%d"\

%hidden _window_status_format=\
"#{p2:}#I #W#{?#F,#F, }#{p2:}"


# Show pane mode
# readonly
# prefix
# tree-mode
# buffer-mode
# view-mode
# copy-mode
%hidden _pane_mode=\
"#{?client_readonly,"\
"#{@fa-lock}readonly,"\
"#[push-default fg=color203]#{?pane_synchronized,sync-on,}#[pop-default default] #{?client_prefix,"\
"prefix,"\
"#{?pane_in_mode,"\
"#{pane_mode},"\
"normal}}}"



# tmux default window status list for statusline portability.
# options:
#   status-justify               (left|centre|right)
#   window-status-style          [styles]
#   window-status-last-style     [styles]
#   window-status-bell-style     [styles]
#   window-status-activity-style [style]
#   window-status-format         [string]
#   window-status-separator      [string]
#   window-status-current-style  [style]
#   window-status-current-format [string]
%hidden _window_list=\
"#[norange default]"\
"#[list=on align=#{status-justify}]"\
"#[list=left-marker]<#[list=right-marker]>#[list=on]"\
"#{W:#[range=window|#{window_index} "\
"#{E:window-status-style}"\
"#{?#{&&:#{window_last_flag},"\
"#{!=:#{E:window-status-last-style},default}}, "\
"#{E:window-status-last-style},}"\
"#{?#{&&:#{window_bell_flag},"\
"#{!=:#{E:window-status-bell-style},default}}, "\
"#{E:window-status-bell-style},"\
"#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},"\
"#{!=:#{E:window-status-activity-style},default}}, "\
"#{E:window-status-activity-style},}}]#[push-default]"\
"#{T:window-status-format}#[pop-default]#[norange default]"\
"#{?window_end_flag,,#{window-status-separator}},"\
"#[range=window|#{window_index} list=focus "\
"#{?#{!=:#{E:window-status-current-style},default},"\
"#{E:window-status-current-style},"\
"#{E:window-status-style}}"\
"#{?#{&&:#{window_last_flag},"\
"#{!=:#{E:window-status-last-style},default}}, "\
"#{E:window-status-last-style},}"\
"#{?#{&&:#{window_bell_flag},"\
"#{!=:#{E:window-status-bell-style},default}}, "\
"#{E:window-status-bell-style},"\
"#{?#{&&:#{||:#{window_activity_flag},"\
"#{window_silence_flag}},"\
"#{!=:#{E:window-status-activity-style},default}}, "\
"#{E:window-status-activity-style},}}]#[push-default]"\
"#{T:window-status-current-format}#[pop-default]"\
"#[norange list=on default]"\
"#{?window_end_flag,,#{window-status-separator}}"\
"}#[bg=colour234, fg=colour235]"

# tmux default status-right format for statusline portability.
# uses:
#   status-right-style [styles]
#   status-right       [string]
%hidden _status_right_format=\
"#[nolist align=right range=right #{E:status-right-style}]"\
"#[push-default]#{T;=/#{status-right-length}:status-right}"\
"#[pop-default]#[norange default]"

# tmux default status-left format for statusline portability.
# uses:
#   status-left-style [styles]
#   status-left       [string]
%hidden _status_left_format=\
"#[align=left range=left #{E:status-left-style}]"\
"#[push-default]#{T;=/#{status-left-length}:status-left}"\
"#[pop-default]"

# pane border format
# user options:
#   @pane-title-position [right|left]
#   @pane-tile           [string]
#   @pane-title-style    [styles]
%hidden _pane_border_format=\
"#[align=#{@pane-title-position} #{@pane-title-style}]"\
"#{E:pad}#{E:@pane-title}#{E:pad}"

# pane border style
# options:
#   pane-border-status (off|top|bottom)
%hidden _pane_border_style=\
"#{?#{||:#{==:#{pane-border-status},top},#{==:#{pane-border-status},bottom}},"\
"#{?pane_in_mode,fg=colour58,fg=#333333},false}"

# window tree format for choose-mode format.
# user options:
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
"#{!=:#{pane_title},#{host_short}}},:\"#{pane_title}\",},"\
"#[#{@tree-window-style}]"\
"#{?window_format,#{window_name}"\
"#[push-default #{@tree-window-flag-style}] #{window_flags}"\
"#{?#{&&:#{==:#{window_panes},1}"\
",#{&&:#{pane_title},#{!=:#{pane_title},#{host_short}}}}, "\
"#[pop-default default]: #[#{@tree-pane-title-style}]\"#{pane_title}\",},"\
"#{?session_attached,"\
"#[#{@tree-session-attached-style}]#{@tree-session-attached-format},"\
"#[#{@tree-session-style}]#{@tree-session-format}}"\
"#{?session_grouped,"\
"(group #{session_group}: #{session_group_list}),"\
"}}}"

# vim-style selection, display selected character/lines count.
%hidden _selection=\
"#{?#{selection_active},"\
"#{?#{e|>:#{e|+:#{?#{e|<:#{selection_end_y},#{selection_start_y}}"\
",#{e|-:#{selection_start_y},#{selection_end_y}}"\
",#{e|-:#{selection_end_y},#{selection_start_y}}"\
"},#{selection_active}},1},"\
"#{e|+:#{?#{e|<:#{selection_end_y},#{selection_start_y}}"\
",#{e|-:#{selection_start_y},#{selection_end_y}}"\
",#{e|-:#{selection_end_y},#{selection_start_y}}"\
"},#{selection_active}} line,"\
"#{e|+:#{?#{e|<:#{selection_end_x},#{selection_start_x}}"\
",#{e|-:#{selection_start_x},#{selection_end_x}}"\
",#{e|-:#{selection_end_x},#{selection_start_x}}"\
"},#{selection_active}} char}/s,}"

%hidden message="#{?#{==:#{E:_selection},},#{E:_message},#{E:_selection}}"
