# vi:ft=tmux

# Variables
#
# Menu options should follow the `@component-state-property` formula for
# consistent naming. Ex: @menu-session-attached-active.

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

%hidden commands="#(tmux show-option command-alias | grep -c '^command-alias\[')"

# wlan0 ssid name.
%hidden wlan0_ssid="#(iw wlan0 link | grep 'SSID' | awk '{ print $2 }')"

# Time format that syncs with clock-mode-style time format.
# user option:
#   clock-mode-style [style]
%hidden _time=\
"#{?#{==:#{clock-mode-style},24},%H,}"\
"#{?#{==:#{clock-mode-style},12},%I,}"\
":%M:%S"\
"#{?#{==:#{clock-mode-style},12}, %p,}"

# Date format that changes styles.
# user options:
#   @month-mode-style  (short|long)
#   @day-mode-style    (short|long)
#   @day-weekend-style [style]
#   @day-weekday-style [style]
%hidden _date=\
"#{?#{==:#{@day-mode-style},short},%a,}"\
"#{?#{==:#{@day-mode-style},long},%A,} "\
"#{?#{==:#{@month-mode-style},short},%b,}"\
"#{?#{==:#{@month-mode-style},long},%B,}"\
"-%d"



# " #{?#{m:-,#{window_flags}},#[fg=red],#[fg=red]}#{window_flags}#{p2:}"


# %hidden _window_status_format=\
# "#{p2:}"\
# "#[push-default #{?#{m:-,#{window_flags}},bg=#{@color_secondary} fg=#{@color-accent},#F}] #{window_name}"\
# "#{p2:}"

# Show pane mode
# normal | readonly | prefix | tree-mode | buffer-mode | view-mode | copy-mode | sync-on
# clock-mode
# user options:
#   @pane-mode-important-style [style]
#     - style for important modes (readonly|sync-on)
#   @pane-mode-style [style]
%hidden pane_modes=\
"#{?client_prefix, prefix ,#{_message}}"\
"#{?client_readonly, read-only ,}"\
"#{?pane_synchronized, sync-on ,}"\
"#{?pane_in_mode,#{pane_mode},}"\
"#{?window_zoomed_flag,zoomed,}"

# -------------- 
# Pane Modes
# -------------- 
# 0.) normal
# 1.) copy-mode
# 2.) clock-mode
# 4.) view-mode (run-shell)
# 3.) tree-mode  (choose-tree)
# 5.) buffer-mode (choose-buffer)
# 6.) client-mode (choose-client)


# prefix, read-only, sync-on, view-mode, zoomed

# mode first
# overriden by prefix




# read-only, sync-on, prefix,

# "#{?client_readonly,"\
# "#[push-default #{@pane-mode-important-style}] read-only #[pop-default default],"\

# "#[push-default #{@pane-mode-important-style}]"\
# "#{?pane_synchronized, sync-on ,}#[pop-default default]"\
# "#[push-default #{@pane-mode-style}]#{?client_prefix,"\
# " prefix ,"\
# "#{?pane_in_mode,"\
# " #{pane_mode} ,"\
# "}}#[pop-default default]}"

# embeddable pane mode style for stateful config status fill
# eg:
#  set -g @status-fill "#{pane_mode_bg}"
%hidden color_mode_bg=\
"#{?client_readonly,"\
"#[push-default #{@color-mode-readonly}] read-only #[pop-default default],"\
"#[push-default #{@pane-mode-important-style}]"\
"#{?pane_synchronized, sync-on ,}#[pop-default default]"\
"#[push-default #{@pane-mode-style}]#{?client_prefix,"\
" prefix ,"\
"#{?pane_in_mode,"\
" #{pane_mode} ,"\
"}}#[pop-default default]}"


# client key table styles
#
%hidden __client_key_table_styles=\
"#{?#{==:#{client_key_table},layout-mode},layout-activated,"\
"#{?#{==:#{client_key_table},resize-mode},resize-activated,false}"\
"}"



# window status styles
#
# Set the status line style for the all windows.
#
# options:
#   @window-status-current-prefix-mode-style [style]
#     - Set the style for current window when client prefix has been pressed.
#   @window-status-current-layout-mode-style [style]
#     - Set the style for current window when layout-mode is activated.
#
# 
%hidden _window_status_styles=\
"#{?#{!=:#{E:window-status-current-style},default},"\
"#{?#{==:#{client_key_table},layout-mode},#{E:@window-status-current-layout-mode-style},"\
"#{?client_prefix,#{E:@window-status-current-prefix-mode-style},#{E:window-status-current-style}}},"\
"#{E:window-status-style},"\
"#{E:window-status-style}}"

# window status index
#
# Set the status line style for all window's index.
#
%hidden _window_status_index_format=\
"#{?#{==:#{client_key_table},layout-mode},"\
"#{?#{e|==:#{window_index},#{e|+:#{active_window_index},1}},#[push-default fg=red]>#[pop-default default],}"\
"#{?#{e|==:#{window_index},#{e|-:#{active_window_index},1}},#[push-default fg=red]<#[pop-default default],}"\
"#{?#{e|==:#{window_index},#{last_window_index}},#[push-default fg=red]$#[pop-default default],}"\
"#{?#{e|==:#{window_index},1},#[push-default fg=red]^#[pop-default default],}"\
"#[push-default #{?client_prefix,fg=#{@color-primary-emphasis},fg=#{@color-primary}}]"\
"#I#[pop-default default] "\
","\
"#[push-default #{?client_prefix,fg=#{@color-primary-emphasis} bold,fg=colour30}]"\
" #I#[pop-default default] }"\


# last, first, next, prev

# if layout-mode {
#
#   if index == first { '^' }
#   if index == last  { '$' }
#   if index == next  { '>' }
#   if index == prev  { '<' }
#
# } else {
#   #{window_index}
# }
#

# if active index === next index {
#   display '>'
# } else {
#   display window index
# }

# if active index === previous index {
#   display '<'
# } else {
#   display window index
# }


# "#{?#{e|==:#{window_index},#{e|+:#{active_window_index},1}},>,}"\
# "#{?#{e|==:#{window_index},#{e|-:#{active_window_index},1}},<,}"\



# format for window status
# user options:
#   @window-status-index-style         [style] 
#   @window-status-current-index-style [style]
%hidden _window_status_format=\
"#{E:_window_status_index_format}#{window_name}"\
"#{window_flags}#{p1:}" 



# tmux default window status list for statusline portability.
# This is the default window status list for tmux,
# Use it if you want to move the window status on different statusbar.
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
"#{E:_window_status_styles}"\
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

# vim-style selection display, display selected character/lines count.
# user options:
#   @visual-line [number]
%hidden _selection=\
"#{?#{selection_active},"\
"#{?#{e|>:#{e|+:#{?#{e|<:#{selection_end_y},#{selection_start_y}}"\
",#{e|-:#{selection_start_y},#{selection_end_y}}"\
",#{e|-:#{selection_end_y},#{selection_start_y}}"\
"},#{selection_active}},1},"\
"#{e|+:#{?#{e|<:#{selection_end_y},#{selection_start_y}}"\
",#{e|-:#{selection_start_y},#{selection_end_y}}"\
",#{e|-:#{selection_end_y},#{selection_start_y}}"\
"},#{selection_active}} lines,"\
"#{e|+:#{?#{e|<:#{selection_end_x},#{selection_start_x}}"\
",#{e|-:#{selection_start_x},#{selection_end_x}}"\
",#{e|-:#{selection_end_x},#{selection_start_x}}"\
"},#{selection_active}} char},}"

%hidden foobar=\
"#{?#{@visual-line},true,false}"

# Show selected characters/lines
# or display a status message
# user options:
#   @status-message-style [style]
%hidden message=\
"#{?#{==:#{E:_selection},},#[push-default #{@status-message-style}]"\
"#{E:_message},#{E:_selection}}#[pop-default default]"
