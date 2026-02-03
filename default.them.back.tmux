# vim: ft=tmux fdm=marker

# terminal window title
set-option -g set-titles-string "#H #S [#W:#P]"

# 0 1  2  3  4  5  6  7
# 8 9 10 11 12 13 14 15

set -g @theme-background "dark"

# base16 color pallete
#
# emphasis - higher than the hue
# subtle   - lower than the hue
#
# roles
#
set -g @color-primary          "colour6"
set -g @color-primary-emphasis "colour14"
set -g @color-primary-subtle   "colour23"

# below this is for checking.
# ===============================

set -g @color-secondary "#6a6e75"
set -g @color-success   "colour255"
set -g @color-info      "colour255"
set -g @color-warning   "colour255"
set -g @color-danger    "colour255"
set -g @color-light     "colour0"
set -g @color-dark      "colour15"


set -gF @color-mode-prefix-style   "bg=#{@color-accent},fg=colour166"

set -g  @color-accent     "colour14"
set -gF @color-accent-prefix ""


set -g @color-background  "colour232" # shows modes



# Menu Styles


# window
# swap left
# swap right
#--------------
# pane
# kill
# respawn
# mark
# rename
# --------------
# new After
# new at the end


set -g menu-style                "bg=colour234,fg=colour255"
set -g menu-selected-style       "bg=colour14,fg=colour234"
set -g @menu-item-left-style     ""
set -g @menu-item-right-style    "fg=colour202"
set -g @menu-item-icon-style     "fg=colour239"
set -g menu-border-style         "bg=colour234"
set -g menu-border-lines         "double"


# Color emphasis for overlapping layouts
# higher index is the top-most layout
set -g @color-bg-emphasis-1 "colour234"
set -g @color-bg-emphasis-2 "colour232"
set -g @color-bg-emphasis-3 ""



# used by color_mode_bg (util.tmux)
set -g @color-mode-copy-style     "bg=orange"

set -g @color-mode-tree     ""
set -g @color-mode-buffer   ""
set -g @color-mode-view     ""
set -g @color-mode-sync     ""
set -g @color-mode-readonly "red"



# status
set -g status                        on
set -g status-position               bottom
set -g status-style                  "bg=colour0,fg=white"
set -g status-bg                     "#212631"
set -g status-fg                     "white"

set -g @status-fill                  "red"
set -g status-justify                "left"
set -g status-left-length            24
set -g status-right-length           100

# message style
set -g message-style                 "bg=colour234,fg=cyan"
set -g message-command-style         "bg=colour234"

# modes
set -g clock-mode-style              12
set -g clock-mode-colour "colour234"
set -g mode-style                    "bg=colour14,fg=colour234"

# window status
# bg=accent
# set -gF window-status-current-style       "bg=#{@color_secondary},fg=#{@color-accent} bold"
set -gF window-status-current-style       "bg=colour3,fg=blue"
set -g @window-status-current-index-style ""

# bg=secondary
set -g window-status-style           "bg=colour232,fg=colour245 bold"
set -g @window-status-index-style    "fg=colour6 none"

set -g window-status-separator       "#[fg=red]|"

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
set -g @day-mode-style               "short"
set -g @day-weekend-style            "bold,fg=colour203"
set -g @day-weekday-style            "bold,fg=red,bg=white"
set -g @month-mode-style             "short"


# indicators (WLAN) false
set -g @ind-wlan-0-char  ""
set -g @ind-wlan-0-icon  "#{@fa-wifi}"
set -g @ind-wlan-0-style "fg=colour246"

# indicators (WLAN) true
set -g @ind-wlan-1-char  ""
set -g @ind-wlan-1-icon  "#{@fa-wifi}"
set -g @ind-wlan-1-style "fg=colour6"
# set -gF @ind-wlan-1-icon  "#{wlan0_ssid}"

set -g @status-message-style         "fg=green"
set -g @status-message-timeout        5

# status left/right
set -g status-left-style             "fg=colour14 bold"
# set -g  status-left                  " #[push-default] #[pop-default default] #S "
set -g  status-left                  "#{?#{pane_mode}, #{pane_mode} , normal }"


# Status right
set -g  status-right-style            "fg=colour14"
set -g  status-right                 "#{@message-log}  "
# set -agF status-right                 "#[push-default fg=colour45]#{pane_modes} #[] │ "
# set -agF status-right                 "#{ind_wlan} │"
# set -agF status-right                 "#{sound}"
# set -agF status-right                 "#{win_drive}  │ "
# set -agF status-right                 "($TMUX_PANE_ACTIVE)"
# set -ag status-right                 "#{user}@#{host_short}  │ "

set -ag status-right                 "(#{client_key_table}) │ "
set -ag status-right                 "#{E:_selection}"
set -ag status-right                 "#{E:_date}  │ "
set -ag status-right                 "#{E:_time} "

# -------------
#  Modes State
# -------------
set -ag status-right                 "#{?window_zoomed_flag,zoomed,}"
set -ag status-right                 "#{?pane_synchronized,synced-on,}"
set -ag status-right                 "#{?client_readonly,read-only,}"
set -ag status-right                 "#{?#{pane_mode},#{p-12:pane_mode},normal}"


# Style for active pane
set -gw window-active-style "bg=#060600"
set -gw window-style        "bg=colour232,fg=colour238"


set -g @pane-mode-style           "bg=colour45,fg=red"
set -g @pane-mode-important-style "bg=colour45,fg=colour4"

# Palette
# status formats
set -g window-status-format         "#{E:_window_status_format}"
set -g window-status-current-format "#{E:_window_status_format}"

# statusline
set -g status-format[0] \
"#[push-default #{status-style}]#{E:_status_left_format}"\
"#{E:_window_list}#[push-default ]"\
"#[pope-default default]#{E:_status_right_format}"\

%hidden mpris=\
"#[push-default fg=colour236]M#[fg=colour237]P#[fg=colour238]R"\
"#[fg=colour239]I#[fg=colour240]S#[fg=colour241]_"\
"#[fg=colour242]#{=40:#{s/\s/_:#{E:mpris_title}}}#[pop-default default]"\
"#[push-default default]#[fg=colour241]_#[fg=colour241]P#[fg=colour240]L"\
"#[fg=colour239]A#[fg=colour238]Y#[fg=colour237]E#[fg=colour236]R"\
"#[pop-default default]"

set -g status-format[1] \
"#[push-default fg=colour242]#{E:current_path}: #{E:_permission}#[align=right]#{E:mpris}"\
