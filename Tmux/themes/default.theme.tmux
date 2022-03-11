# vim: ft=tmux fdm=marker
#
# description: modal statusbar theme

source-file ${DOT_TMUX}"/lib/*"

# Modal statusbar fill (normal|copy|prefix).
# user options:
#   @prefix-mode-fill [colour]
#   @copy-mode-fill   [colour]
#   @normal-mode-fill [colour]
%hidden _status_client_mode_fill=\
"#{?client_readonly,"\
"#{@readonly-mode-fill},"\
"#{?client_prefix,"\
"#{@prefix-mode-fill},"\
"#{?pane_in_mode,"\
"#{@copy-mode-fill},"\
"#{@normal-mode-fill}}}}"

# component A style
%hidden _status_comp_a_style=\
"#{?client_readonly,"\
"#{@readonly-status-comp-a-style},"\
"#{?client_prefix,"\
"#{@prefix-status-comp-a-style},"\
"#{?pane_in_mode,"\
"#{@copy-status-comp-a-style},"\
"#{@normal-status-comp-a-style}}}"\
"}"
# component B style
%hidden _status_comp_b_style=\
"#{?client_readonly,"\
"#{@readonly-status-comp-b-style},"\
"#{?client_prefix,"\
"#{@prefix-status-comp-b-style},"\
"#{?pane_in_mode,"\
"#{@copy-status-comp-b-style},"\
"#{@normal-status-comp-b-style}}}"\
"}"
# component C style
%hidden _status_comp_c_style=\
"#{?client_readonly,"\
"#{@readonly-status-comp-c-style},"\
"#{?client_prefix,"\
"#{@prefix-status-comp-c-style},"\
"#{?pane_in_mode,"\
"#{@copy-status-comp-c-style},"\
"#{@normal-status-comp-c-style}}}"\
"}"

# theme starts here..

set-option -g clock-mode-style   12
set-option -g status 2
set-option -g status-justify left

# modal styles
set -g @prefix-mode-fill           "colour24"
set -g @copy-mode-fill             "colour94"
set -g @normal-mode-fill           "colour236"
set -g @readonly-mode-fill         "colour124"

set-option -g @glyph-style "bold,fg=colour250"

set-option -gF status-style "bg=#{@normal-mode-fill},fg=colour247"

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
set-option -g @day-mode-style    "long"
set-option -g @month-mode-style  "long"
set-option -g @day-weekend-style "bold,fg=colour203"
set-option -g @day-weekday-style "default"

# _window_list styles
set-option -g status-justify "centre"
set-option -gF window-status-current-style "bg=colour237,fg=colour250"  #"#{_status_comp_b_style}"
set-option -g window-status-style "bg=colour235,fg=colour245"
#"#{?client_readonly,"\
#"#{@readonly-status-comp-c-style},"\
#"#{?client_prefix,"\
#"#{@prefix-status-comp-c-style},"\
#"#{W:#{?window_active,"\
#"#{?pane_in_mode,"\
#"#{@copy-status-comp-c-style}"\
#",#{@normal-status-comp-c-style}},}}}}"

# window status format
set-option -gF window-status-separator ''

set-option -g window-status-format \
"#[push-default bold,fg=cyan] #I#[pop-default default]: "\
"#W "\
"#{?#{==:#F,}, ,#F} "

set-option -g window-status-current-format \
"#[push-default bold,fg=cyan] #I#[pop-default default]: "\
"#W "\
"#{?#{==:#F,}, ,#F} "

set-option -g  status-left-length  70
set-option -gF status-left \
"#[#{_status_comp_a_style}] #{_session_name} #[reverse]#{@pl-separator-right}"\
"#[#{_status_comp_b_style}] #{_pwd} "\
"#[#{_status_comp_c_style}] #{@pl-code-branch} (#{_git_branch}) #{_git_latest_commit} #{@pl-thin-separator-right} "

set-option -g  status-right-length 100
set-option -gF status-right \
"#[#{_status_comp_c_style}] #{@pl-thin-separator-left} #{@fa-wifi} #{_wifi_ssid}"\
"#[#{_status_comp_c_style}] #{@pl-thin-separator-left} #{@fa-calendar-alt} #{_day} #{_date}  "\
"#[#{_status_comp_b_style}] #{@fa-clock} #{_time}  "\
"#[#{_status_comp_a_style}]  #{_user}@#{_pane_title}"\

# status format
set-option -g status-format[0] \
"#{?client_readonly,"\
"#[fg=colour203]#{@fa-lock} client is in readonly mode. Press #{prefix} + R to toggle."\
","\
"#{E:_status_left_format}"\
"#[fill=#{E:_status_client_mode_fill}]"\
"#{E:_status_right_format}"\
"}"
set-option -gF status-format[1] \
"#{@fa-th-large} #{_window_list}"\
"#[fill=colour234]"\
"#[nolist align=right]"\
"#[bg=colour234]"\
"#{?#{!=:#{_yt_current_playing_song},},#{@fa-headphones}#[fg=colour241] #{=40:#{E:_yt_current_playing_song}},}"
