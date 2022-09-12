# vim: ft=tmux fdm=marker
#
# description: modal statusbar theme

# Modal statusbar fill (readonly|normal|copy|prefix). {{{1
# user options:
#   @prefix-mode-fill   [colour]
#   @copy-mode-fill     [colour]
#   @normal-mode-fill   [colour]
#   @readonly-mode-fill [colour]
#
%hidden _status_client_mode_fill=\
"#{?client_readonly,"\
"#{@readonly-mode-fill},"\
"#{?client_prefix,"\
"#{@prefix-mode-fill},"\
"#{?pane_in_mode,"\
"#{@copy-mode-fill},"\
"#{@normal-mode-fill}}}}"

# segment A style
%hidden _segment_a_style=\
"#{?client_readonly,"\
"#{@readonly-status-comp-a-style},"\
"#{?client_prefix,"\
"#{@prefix-status-comp-a-style},"\
"#{?pane_in_mode,"\
"#{@copy-status-comp-a-style},"\
"#{@normal-status-comp-a-style}}}"\
"}"

# segment B style
%hidden _segment_b_style=\
"#{?client_readonly,"\
"#{@readonly-status-comp-b-style},"\
"#{?client_prefix,"\
"#{@prefix-status-comp-b-style},"\
"#{?pane_in_mode,"\
"#{@copy-status-comp-b-style},"\
"#{@normal-status-comp-b-style}}}"\
"}"

# segment C style
%hidden _segment_c_style=\
"#{?client_readonly,"\
"#{@readonly-status-comp-c-style},"\
"#{?client_prefix,"\
"#{@prefix-status-comp-c-style},"\
"#{?pane_in_mode,"\
"#{@copy-status-comp-c-style},"\
"#{@normal-status-comp-c-style}}}"\
"}"

# choose-tree
set-option -g @tree-window-style 'fg=orange'
set-option -g @tree-window-flag-style 'fg=colour35'

set-option -g @tree-pane-title-style 'fg=white'

set-option -g @tree-session-attached-format '(attached)'
set-option -g @tree-session-attached-style 'fg=colour35'

set-option -g @tree-session-format '(unattached)'
set-option -g @tree-session-style 'fg=colour203'

set-option -g @tree-pane-active-flag '*'
set-option -g @tree-pane-active-flag-style 'fg=colour35'

# buffers
set-option -g @buffer-sample-style 'fg=colour35'


set-option -g @buffer-space-alignment 1

# there is no way to know the size of a glyph
set-option -g @buffer-glyph-count 2
set-option -g @buffer-format ""
# set-option -g @buffer-format "#{_day} #{_date} #{_time}"

# menubars - - - - - - - - - - - - - - - - - - - -

set-option -g @menu-title-style        ""
set-option -g @menu-title-active-style "bold,fg=cyan"

# @note: setting bold here causes icon alignment issues.
set-option -g @menu-icon-style "fg=cyan"
set-option -g @menu-icon-prefix " "
set-option -g @menu-icon-suffix "  "

# modal styles
set -g @prefix-mode-fill   "colour24"
set -g @copy-mode-fill     "colour94"
set -g @normal-mode-fill   "colour236"
set -g @readonly-mode-fill "colour124"

set-option -g @glyph-style "bold,fg=colour202"
set-option -g @separator-style "bold,fg=colour234"

set-option -gF status-style   "bg=#{@normal-mode-fill},fg=colour247"
set-option -g  @status1-bg "colour234"

# segments style
set-option -g  @readonly-status-comp-a-style "bold,bg=colour210,fg=colour124"
set-option -g  @readonly-status-comp-b-style "default,bg=colour196,fg=colour253"
set-option -gF @readonly-status-comp-c-style "default,bg=#{@readonly-mode-fill},fg=colour203"

set-option -g  @normal-status-comp-a-style "bold,bg=colour253,fg=colour240"
set-option -g  @normal-status-comp-b-style "default,bg=colour240,fg=colour231"
set-option -gF @normal-status-comp-c-style "default,bg=#{@normal-mode-fill},fg=colour248"

set-option -g  @prefix-status-comp-a-style "bold,bg=colour117,fg=colour23"
set-option -g  @prefix-status-comp-b-style "default,bg=colour31,fg=colour231"
set-option -gF @prefix-status-comp-c-style "default,bg=#{@prefix-mode-fill},fg=cyan"

set-option -g  @copy-status-comp-a-style   "bold,bg=colour185,fg=colour94"
set-option -g  @copy-status-comp-b-style   "default,bg=colour136,fg=colour231"
set-option -gF @copy-status-comp-c-style   "bg=#{@copy-mode-fill},fg=colour180"

# modal command prompt styles
set-option -g message-style         "bg=colour234,fg=cyan"
set-option -g message-command-style "bg=colour234"

set-option -g pane-mode-changed[42] 'set -g message-style fg=orange'

# component styles
set-option -g @day-mode-style    "short"
set-option -g @month-mode-style  "long"
set-option -g @day-weekend-style "bold,fg=colour203"
set-option -g @day-weekday-style "default"

# _window_list styles
set-option -g status-justify "centre"
set-option -gF window-status-current-style "bg=colour237,fg=colour250"
set-option -g window-status-style "bg=colour235,fg=colour245"

# window status format
set-option -gF window-status-separator '#[fg=colour238, bold]│'

set-option -g window-status-format \
"#[push-default bold,fg=cyan] #I#[pop-default default]: "\
"#W "\
"#{?#{==:#F,}, ,#F} "

set-option -g window-status-current-format \
"#[push-default bold,fg=cyan] #I#[pop-default default]: "\
"#W "\
"#{?#{==:#F,}, ,#F} "

set-option -g  status-left-length  70
# set-option -gF status-left \
# "#[#{_segment_a_style}] #{_pane_mode} #[reverse]#{@pl-separator-right}"\
# "#[#{_segment_b_style}] #{_pwd_tilde} "\
# "#[#{_segment_c_style}] #{@pl-code-branch} (#{_git_branch}) #{_git_latest_commit} #{@pl-thin-separator-right} "

set-option -gF status-left \
"#[#{_segment_a_style}] #{b:socket_path} "\
"#[#{_segment_b_style}] #S:#{session_windows} #[reverse]"\
"#[#{_segment_c_style}]    #{_permission}"\
"#[#{_segment_c_style}] #{@pl-thin-separator-right} #{_pwd_tilde} "\

set-option -g  status-right-length 100
# set-option -gF status-right \
# "#[#{_segment_c_style}] #{@pl-thin-separator-left} #{?#{==:#{E:_has_headset},connected},#{@fa-headphones} headphones,#{@fa-volume} speaker}"\
# "#[#{_segment_c_style}] #{@pl-thin-separator-left} #{@fa-wifi} #{@fa-no-wifi} #{_wifi_ssid}"\
# "#[#{_segment_c_style}] #{@pl-thin-separator-left} #{_user}@#{host} "\
# "#[#{_segment_b_style}] #{_day} #{_date} "\
# "#[#{_segment_a_style}] #{_time} "\

set-option -gF status-right \
"#[#{_segment_c_style},bold] #{@fa-wifi} #{@fa-headphones}        "\
"#[#{_segment_c_style}] #{@pl-thin-separator-left}#{client_user}@#{host} "\
"#[#{_segment_b_style}] #{_day} #{_date} "\
"#[#{_segment_a_style}] #{_time} "\

# status format {{{1
set-option -g status-format[0] \
"#{?client_readonly,"\
"#[fg=colour203]#{@fa-lock} client is in readonly mode. Press <#{prefix}> + R to toggle."\
","\
"#{E:_status_left_format}"\
"#[fill=#{E:_status_client_mode_fill}]"\
"#{E:_status_right_format}"\
"}"

set-option -g status-format[1] \
"#[fill=#{@status1-bg} align=left] #{E:@fa-th-large} #{E:_window_list}"\
"#[nolist push-default align=right fg=colour242]"\
"#{T;=/#{@status-right-1-length}:"\
"#{_selection}"\
"}"

set-option -g pane-border-status "off"
set-option -g pane-border-format ""

set-option -g pane-border-lines "heavy"
set-option -g pane-border-style "fg=#333333,bg=#222222"  # terminalbg
set-option -g pane-active-border-style "fg=#333333,bg=#222222"

set-option -g window-style        "bg=#222222"
set-option -g window-active-style "bg=#1E1E1E"

set-option -g clock-mode-style   12
set-option -g status 2
set-option -g status-justify centre

set-option -g mode-style 'bg=colour237'
