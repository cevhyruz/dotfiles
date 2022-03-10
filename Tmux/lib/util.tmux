# ---------------------------------------------------------------------
#  File:        util.tmux
#  Description: Useful command-alias to make tmux sensible
# ---------------------------------------------------------------------
# vi:ft=tmux

# user options
#   @glyph-style [stylese]

# required font-awesome
set-option -g @fa-calendar       "\uf133"  # 
set-option -g @fa-calendar-alt   "#[push-default #{@glyph-style}] \uf073 #[pop-default default]"  # 
set-option -g @fa-wifi           "#[push-default #{@glyph-style}] \uf1eb #[pop-default default]"  # 
set-option -g @fa-code-branch    "#[push-default #{@glyph-style}] \uf126 #[pop-default default]"  # 
set-option -g @fa-clock          "#[push-default #{@glyph-style}] \uf017 #[pop-default default]"  # 
set-option -g @fa-circle         "#[push-default #{@glyph-style}] \uf111 #[pop-default default]"  # 
set-option -g @fa-desktop        "#[push-default #{@glyph-style}] \uf108 #[pop-default default]"  # 
set-option -g @fa-cog            "#[push-default #{@glyph-style}] \uf013 #[pop-default default]"  # 
set-option -g @fa-headphones     "#[push-default #{@glyph-style}] \uf025 #[pop-default default]"  # 
set-option -g @fa-lock           "#[push-defualt #{@glyph-style}] \uf023 #[pop-default default]"  # 
set-option -g @fa-folder         "#[push-default #{@glyph-style}] \uf07b #[pop-default default]"  # 
set-option -g @fa-folder         "#[push-default #{@glyph-style}] \uf07c #[pop-default default]"  # 
set-option -g @fa-laptop         "#[push-default #{@glyph-style}] \uf109 #[pop-default default]"  # 
set-option -g @fa-bullhorn       "#[push-default #{@glyph-style}] \uf0a1 #[pop-default default]"  # 
set-option -g @fa-comment        "#[push-default #{@glyph-style}] \uf075 #[pop-default default]"  # 
set-option -g @fa-envelope       "#[push-default #{@glyph-style}] \uf0e0 #[pop-default default]"  # 
set-option -g @fa-file           "#[push-default #{@glyph-style}] \uf1b5 #[pop-default default]"  # 
set-option -g @fa-play           "#[push-default #{@glyph-style}] \uf04b #[pop-default default]"  # 
set-option -g @fa-stop           "#[push-default #{@glyph-style}] \uf04d #[pop-default default]"  # 
set-option -g @fa-star           "#[push-default #{@glyph-style}] \uf005 #[pop-default default]"  # 
set-option -g @fa-toggle-on      "#[push-default #{@glyph-style}] \uf205 #[pop-default default]"  # 
set-option -g @fa-toggle-off     "#[push-default #{@glyph-style}] \uf204 #[pop-default default]"  # 
set-option -g @fa-check-square   "#[push-default #{@glyph-style}] \uf14a #[pop-default default]"  # 
set-option -g @fa-mouse-pointer  "#[push-default #{@glyph-style}] \uf245 #[pop-default default]"  # 
set-option -g @fa-th-large       "#[push-default #{@glyph-style}] \uf009 #[pop-default default]"  # 

# required powerline-extra-symbols
set-option -g @pl-thin-separator-left  "#[push-default #{@glyph-style}] \ue0b3 #[pop-default default]" # 
set-option -g @pl-thin-separator-right "#[push-default #{@glyph-style}] \ue0b1 #[pop-default default]" # 
set-option -g @pl-separator-left       "\ue0b2 #[pop-default default]" # 
set-option -g @pl-separator-right      "\ue0b0 #[pop-default default]" # 
set-option -g @pl-code-branch          "#[push-default #{@glyph-style}] \ue0a0 #[pop-default default]" # 
