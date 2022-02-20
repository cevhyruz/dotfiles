# vi:ft=tmux
# ---------------------------------------------------------------------------
# File:        powerline.tmux
# Colorscheme: monochromatic
# Type:        two lined statusbar,dark, powerline
# ---------------------------------------------------------------------------

# https://gist.github.com/sindresorhus/bed863fb8bedf023b833c88c322e44f9
# Color Pallete
# Monochromatic is a single Hue / base
# shades and/or tones - darker color
# tint - ligther color
# Compatible tmux => 1.9
# atleast 2.0

# format from https://github.com/arcticicestudio/nord-tmux

# Theme Pallete

set-option -g status 2

%hidden clock_fmt="12"


set-option -g message-style "fg=white,bg=colour235"

# Theme Options

set-option -g status on
set-option -g status-position "bottom"
set-option -g status-justify "centre"

set-option -g display-panes-time 5000
set-option -g display-panes-active-colour ${PRIMARY}
set-option -g display-panes-colour        ${TINT1}

set-option -g status-bg "${STATUS_BG}"
set-option -g status-fg "${PRIMARY}"

set-window-option -g clock-mode-style ${clock_fmt}
set-window-option -g clock-mode-colour ${TINT2}

set-option -g renumber-windows on
set-option -g base-index 1

# [!] changing STATUS_BG color of pane is not possible until 2.1
if-shell -b '[ "$(echo "$TMUX_VERSION >= 2.1" | bc)" = 1 ]' \
"  set-option -g window-style        "bg=${STATUS_BG}";        \
   set-option -g window-active-style "bg=${WINDOW_STATUS_BG}"; \
"

# [!] TrueColors will be available at 2.2
# ...

set-window-option -g window-status-separator ""

# [!] format modifiers to expand a format twice (T:, E:) is not available until 3.0
# window-status-format

set-window-option -g window-status-current-format \
"#[bg="${WINDOW_STATUS_CURRENT_BG}", fg="${STATUS_BG}"] "\
"#[fg="${COMPLIMENT}"]#I"\
"#[fg="${WINDOW_STATUS_CURRENT_FG}", bg="${WINDOW_STATUS_CURRENT_BG}"]   \uf15b #W "\
"#[fg="${PRIMARY}"]#F "\
"#[bg="${STATUS_BG}", fg="${WINDOW_STATUS_CURRENT_BG}"]"

set-window-option -g window-status-format \
"#[bg="${WINDOW_STATUS_BG}", fg="${STATUS_BG}"]"\
"#[bg="${WINDOW_STATUS_BG}", fg="${COMPLIMENT}"] #I "\
"#[fg="${TINT2}"]  #W "\
"#[fg="red"]#F "\
"#[fg="${WINDOW_STATUS_BG}", bg="${STATUS_BG}"]"

# [!] status-format is not available until 2.9
# status-left
set-option -g status-left-length  70

set-option -g status-left \
"#[bg="${PRIMARY}",fg="${TINT}"] #S "\
"#[fg="${PRIMARY}",bg="${STATUS_BG}"]"\
" #{pane_current_path}"

# status-right
set-option -g status-right-length 70

set-option -g  status-right \
"${wifi} "\
"#[bg="colour237",fg="${PRIMARY}"] %d-%b-%y"\
"#[fg="${TINT1}"] "\
"#[fg="${PRIMARY}",bg=colour239] %H:%M "\
"#[bg="${PRIMARY}",fg="${TINT}"] #H "
