
# vi:ft=tmux
# required powerline-extra-symbols
set-option -g @pl-thin-separator-left  "#[push-default #{@separator-style}] \ue0b3 #[pop-default default]" # 
set-option -g @pl-thin-separator-right "#[push-default #{@separator-style}] \ue0b1 #[pop-default default]" # 
set-option -g @pl-separator-left       "\ue0b2 #[pop-default default]" # 
set-option -g @pl-separator-right      "\ue0b0 #[pop-default default]" # 
set-option -g @pl-code-branch          "#[push-default #{@glyph-style}] \ue0a0 #[pop-default default]" # 
