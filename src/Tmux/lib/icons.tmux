# vi:ft=tmux

set-option -g @icon-disable "fg=colour234,bold"

set-option -g @fa-no-wifi "#[#{@icon-disable}] "
set-option -g @fa-wifi " "

set-option -g @fa-no-headphones "#[#{@icon-disable}]"
set-option -g @fa-headphones " "

set-option -g @u-headphones "🎧"

set-option -g @fa-volume-up "    "

set-option -g @fa-lock ""
set-option -g @fa-windows ""

# required powerline-extra-symbols
set-option -g @pl-thin-separator-left  "#[push-default #{@separator-style}] \ue0b3 #[pop-default default]" # 
set-option -g @pl-thin-separator-right "#[push-default #{@separator-style}] \ue0b1 #[pop-default default]" # 
set-option -g @pl-separator-left       "\ue0b2 #[pop-default default]" # 
set-option -g @pl-separator-right      "\ue0b0 #[pop-default default]" # 
set-option -g @pl-code-branch          "#[push-default #{@glyph-style}] \ue0a0 #[pop-default default]" # 
