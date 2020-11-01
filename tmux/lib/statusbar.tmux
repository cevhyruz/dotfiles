# vi:ft=tmux fdm=marker
# ---------------------------------------------------------------------------
#        FILE : statusbar.tmux
# DESCRIPTION : default tmux statusbar components API.
#       USAGE : source this after the {theme}.conf file.
# ---------------------------------------------------------------------------

# truncate markers (addition)
%if "#{!=:#{||:#{@truncate-left-marker},#{@truncate-right-marker}},}"
  set -g @l_marker "#{@truncate-left-marker}"
  set -g @r_marker "#{@truncate-right-marker}"
  set -g @_tr \
"#[list=left-marker #{@truncate-marker-style}]"\
"#{E:@l_marker}#[list=right-marker]#{E:@r_marker}"
%endif

# window status surround (addition)
%if "#{!=:#{@win-surround-style},}"
  set -g @l_border \
    "#[push-default #{@win-surround-style}]#{@win-surround-left}#[pop-default]"
  set -g @r_border \
    "#[push-default #{@win-surround-style}]#{@win-surround-right}#[pop-default]"
%endif

set -g automatic-rename-format \
"#{?pane_in_mode,[tmux],#{pane_current_command}}#{?pane_dead,[dead],}"

# window list broken into smaller parts
set -g @_ls "#{!=:#{window-status-last-style},default}"
set -g @_bs "#{!=:#{window-status-bell-style},default}"
set -g @_cs "#{!=:#{window-status-current-style},default}"
set -g @_as "#{!=:#{window-status-activity-style},default}"
set -g @_lf "#{&&:#{window_last_flag},#{E:@_ls}}"
set -g @_bf "#{&&:#{window_bell_flag},#{E:@_bs}}"
set -g @_af "#{&&:#{E:@waf},#{E:@_as}}"
set -g @waf "#{||:#{window_activity_flag},#{window_silence_flag}}"
set -g @wls "#{?#{E:@_lf}, #{window-status-last-style},}"
set -g @was "#{?#{E:@_af}, #{window-status-activity-style},}"
set -g @wcs "#{?#{E:@_cs},#{window-status-current-style},#{window-status-style}}"
set -g @wbs "#{?#{E:@_bf}, #{window-status-bell-style},#{E:@was}}"
set -g @sep "#{?window_end_flag,,#{window-status-separator}}"

set -g @session_list "#{S:[#{session_name}]}"

# window status (modified default)
set -g @window_list \
"#[list=on align=#{status-justify}]#{E:@_tr}#[list=on default]"\
"#{E:@l_border}#{W:#[range=window|#I #{window-status-style}#{E:@wls}#{E:@wbs}]"\
"#[push-default]#{T:window-status-format}#[pop-default]#[norange default]"\
"#{E:@sep},#[range=window|#I list=focus #{E:@wcs}#{E:@wls}#{E:@wbs}]"\
"#[push-default]#{T:window-status-current-format}#[pop-default]"\
"#[norange list=on default]#{E:@sep}}#{E:@r_border}"

# status-left-format (default)
set -g @status-left-format \
"#[align=left range=left #{status-left-style}]"\
"#[push-default] #{T;=/#{status-left-length}:status-left}#[pop-default]"

# status-right-format (default)
set -g @status-right-format \
"#[nolist align=right range=right #{status-right-style}]"\
"#[push-default]#{T;=/#{status-right-length}:status-right} #[pop-default]"
