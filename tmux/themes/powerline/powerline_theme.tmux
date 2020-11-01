# ---------------------------------------------------------------------------
# File:        powerline.tmux
# Description: styles, length, colors, and position only
# ---------------------------------------------------------------------------
# vi:ft=tmux

# pallete
%hidden powerline_bg_main="colour235"
%hidden powerline_fg_light="white"
%hidden powerline_status="colour237"
%hidden powerline_current="colour237"
%hidden powerline_left_status="#81A1C1"

set -g @powerline                   on
set -g status                       on
set -g status-position              "bottom"
set -g status-justify               "left"
set -g status-style                 "bg=$powerline_bg_main"
set -g @win-surround-left           ""
set -g @win-surround-right          ""
set -g @win-surround-style          "fg=yellow, bg=default"
set -g @truncate-left-marker        "[...]"
set -g @truncate-right-marker       "[...]"
set -g @truncate-marker-style       "bg=yellow, fg=red"
set -g status-bg                    "${powerline_bg_main}"
set -g @status-bg-1                 "colour23"
set -g @status-bg-2                 "colour23"
set -g status-fg                    "yellow"
set -g @status-fg-1                 "red"
set -g @status-fg-2                 "yellow"
set -g status-left-style            "fg=$powerline_bg_main, bg=$powerline_left_status"
set -g status-left-length           70
set -g status-right-style           "bold fg=$powerline_bg_main, bg=$powerline_left_status"
set -g status-right-length          70
set -g window-active-style          "none"
set -g window-style                 "none"
set -g pane-active-border-style     "fg=$powerline_left_status"
set -g pane-border-style            "fg=$powerline_left_status"
set -g clock-mode-style             12
set -g mode-style                   "fg=white, bg=colour239, bold"
set -g window-status-activity-style "bg=black, fg=white, dotted-underscore"
set -g window-status-bell-style     "bg=red"
set -g window-status-current-style  "bg=$powerline_current, fg=$powerline_left_status"
set -g window-status-style          "fg=$powerline_left_status, bg=$powerline_status"
set -g window-status-last-style     "bg=$powerline_status, fg=$powerline_left_status"
set -g window-status-separator      ""
set -g message-command-style        "bg=black, fg=red"
set -g message-style                "bg=colour234, fg=colour249"
