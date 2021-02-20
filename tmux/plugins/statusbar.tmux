# ---------------------------------------------------------------------------
# File:        statusbar.tmux
# Description: portable tmux statusbar that supports themeing.
# ---------------------------------------------------------------------------
# vi:ft=tmux

# truncate markers (addition)
#%if "#{!=:#{||:#{@truncate-left-marker},#{@truncate-right-marker}},}"
  #set -g @l_marker "#{@truncate-left-marker}"
  #set -g @r_marker "#{@truncate-right-marker}"
  #set -g @_tr \
#"#[list=left-marker #{@truncate-marker-style}]"\
#"#{E:@l_marker}#[list=right-marker]#{E:@r_marker}"
#%endif

# window status surround (addition)
#%if "#{!=:#{@win-surround-style},}"
  #set -g @l_border \
    #"#[push-default #{@win-surround-style}]#{@win-surround-left}#[pop-default]"
  #set -g @r_border \
    #"#[push-default #{@win-surround-style}]#{@win-surround-right}#[pop-default]"
#%endif

## window list broken into smaller parts

# check if styles is not default
#set -g @_window-status-last-style "#{!=:#{window-status-last-style},default}"
#set -g @_bell-style "#{!=:#{window-status-bell-style},default}"
#set -g @_current-style "#{!=:#{window-status-current-style},default}"
#set -g @_activity-style "#{!=:#{window-status-activity-style},default}"


## if window_last_flag is set and _window-status-last-style is NOT default
#set -g @_last-flag "#{&&:#{window_last_flag},#{E:@_window-status-last-style}}"

## if window_bell_flag is set and _bell-style is NOT default
#set -g @_bell-flag "#{&&:#{window_bell_flag},#{E:@_bell-style}}"


## if either activity and silence flag is set
#set -g @flag "#{||:#{window_activity_flag},#{window_silence_flag}}"


## if either flag is set and window-status-activiy-style is NOT default
#set -g @_activity-flag "#{&&:#{E:@flag},#{E:@_activity-style}}"

#set -g @wls "#{?#{E:@_last-flag}, #{window-status-last-style},}"
#set -g @_activity_style "#{?#{E:@_activity-flag}, #{window-status-activity-style},}"

#set -g @wcs "#{?#{E:@_current-style}, #{window-status-current-style},#{window-status-style}}"

#set -g @wbs "#{?#{E:@_bell-flag}, #{window-status-bell-style},#{E:@_activity_style}}"

 #set -g @sep "#{?window_end_flag,#{window-status-separator},#{window-status-separator}}"

## window status (modified default)
#set -g @_window_list \
#"#[list=on align=#{status-justify}]#{E:@_tr}#[list=on default]"\
#"#{E:@l_border}#{W:#[range=window|#I #{window-status-style}#{E:@wls}#{E:@wbs}]"\
#"#[push-default]#{T:window-status-format}#[pop-default]#[norange default]"\
#"#{E:@sep},#[range=window|#I list=focus #{E:@wcs}#{E:@wls}#{E:@wbs}]"\
#"#[push-default]#{T:window-status-current-format}#[pop-default]"\
#"#[norange list=on default]#{E:@sep}}#{E:@r_border}"

## -----------------------------------------------------------------------------
## format

#set -g status-left \
#"#[bold]#{=4:client_key_table} #[fg=$SHADE, bg=$PRIMARY]"\
#" #[bold]#{session_name} "

#set -g @_status_right_wrapper "#[bg=$PRIMARY, fg=$SHADE$]#[default]"
#set -g status-right \
#"#{E:@_status_right_wrapper} %Y-%m-%d #{E:@_status_right_wrapper} %I:%M"

#set -g @hah "#[fg=$PRIMARY, bg=$COMPLIMENT]#[default]"
#set -g @hoh "#[bg=$TERTIARY, fg=$PRIMARY]#[default]"

#set -g @fmt "#[bold, fg=colour232]#[default]"
#set -g window-status-format \
#"#{E:@hoh} #[bold]#{window_index} #{E:@fmt} #{window_name} "\
#"#{?window_flags,#[bold fg=colour245]#{window_flags} #[reverse]#{E:@hoh},  #[reverse bold]#{E:@hoh}}"

#set -g window-status-current-format \
#"#{E:@hah} #[bold]#{window_index} #{E:@fmt} #{window_name} "\
#"#{?window_flags,#[bold fg=yellow]#{window_flags} #[reverse]#{E:@hah},  #[reverse]#{E:@hah}}"


## status-left-format (default)
#set -g @status-left-format \
#"#[align=left range=left #{status-left-style}]"\
#"#[push-default] #{T;=/#{status-left-length}:status-left}#[pop-default]"

## status-right-format (default)
#set -g @status-right-format \
#"#[nolist align=right range=right #{status-right-style}]"\
#"#[push-default]#{T;=/#{status-right-length}:status-right} #[pop-default]"

#set-option -g status-format[0] \
#"#[fill=red}]#{E:@status-left-format}"\
#"#{E:@window_list}#{E:@status-right-format}"
