# vi:ft=tmux
# ---------------------------------------------------------------------------
# File:        powerline.tmux
# Colorscheme: monochromatic
# Type:        dark, powerline
# ---------------------------------------------------------------------------

# https://gist.github.com/sindresorhus/bed863fb8bedf023b833c88c322e44f9
# Color Pallete
# Monochromatic is a single Hue / base
# shades and/or tones - darker color
# tint - ligther color
# Compatible tmux => 1.9
# atleast 2.0

set-option -g default-terminal screen-256color


# Theme Pallete

# win-current-bg = Primary + 222
# win-bg = win-current-bg - 2

PRIMARY="colour15"
COMPLIMENT="yellow"

BACKGROUND="colour235" # opposite of primary, for contrast
TINT="colour236"
TINT1="colour239"
TINT2="colour243"


# Theme component (core components)


STATUS_BG="colour235"
WINDOW_STATUS_BG="colour236"
WINDOW_STATUS_CURRENT_BG="colour237"
WINDOW_STATUS_CURRENT_FG="${PRIMARY}"

# Theme Options

set-option -g status on
set-option -g status-position "bottom"
set-option -g status-justify "left"


# statusbar style
if-shell '[ "$(echo "${TMUX_VERSION} < 2.9" | bc)" = 1 ]' \
"  set-option -g status-bg "${STATUS_BG}"; \
   set-option -g status-fg "${PRIMARY}"; \
   set-option -g status-attr "default"; \
   \
   set-option -g status-left-bg "${PRIMARY}"; \
   set-option -g status-left-fg "${BACKGROUND}"; \
   set-option -g status-left-attr "default"; \
   \
   set-option -g status-right-bg "colour233"; \
   set-option -g status-right-fg "${SHADE}"; \
   set-option -g status-right-attr "default"; \
   \
   set-option -g mode-bg "blue"; \
   set-option -g mode-fg "red"; \
   set-option -g mode-attr "default"; \
   \
   set-option -g message-bg "green"; \
   set-option -g message-fg "black"; \
   set-option -g message-attr "default"; \
   \
   set-option -g message-command-bg "black"; \
   set-option -g message-command-fg "red"; \
   set-option -g message-command-attr "default"; \
   \
   set-option -g pane-border-bg "default"; \
   set-option -g pane-border-fg "white"; \
   \
   set-option -g pane-active-border-bg "default"; \
   set-option -g pane-active-border-fg "white"; \
"

#  may have some incompatibilities
set-window-option -g window-status-current-style 'bold'
set-window-option -g window-status-style         'bold'


set-window-option -g clock-mode-style 24
set-window-option -g clock-mode-colour ${PRIMARY}

set-option -g renumber-windows on
set-option -g base-index 1

# changing STATUS_BG color of pane is not possible until 2.1


# TrueColors not available until 2.2 We can only use a
# 256 color palette: 216 colors + 16 ANSI + 24 gray (colors are 24-bit)


if-shell -b '[ "$(echo "$TMUX_VERSION >= 2.1" | bc)" = 1 ]' \
               "set -g window-active-style none; \
                set -g window-style none;"


set-option -g clock-mode-style             24


# window-status-format

# format modifiers to expand a format twice (T:, E:) is not available until 3.0


set-window-option -g window-status-current-format \
"#[bg="${WINDOW_STATUS_CURRENT_BG}", fg="${STATUS_BG}"] "\
"#[fg="${COMPLIMENT}"]#I"\
"#[fg="${WINDOW_STATUS_CURRENT_FG}", bg="${WINDOW_STATUS_CURRENT_BG}"]   #W "\
"#[fg="${PRIMARY}"]#F "\
"#[bold, bg="${STATUS_BG}", fg="${WINDOW_STATUS_CURRENT_BG}"]"


set-window-option -g window-status-format \
"#[bg="${WINDOW_STATUS_BG}", fg="${STATUS_BG}"]"\
"#[bg="${WINDOW_STATUS_BG}", fg="${COMPLIMENT}"] #I "\
"#[fg="${TINT2}"]  #W "\
"#[fg="${PRIMARY}"]#F "\
"#[fg="${WINDOW_STATUS_BG}", bg="${STATUS_BG}"]"



set-window-option -g window-status-separator ""

# status-format is not available until 2.9

set-option -g status-left-length  70
set-option -g status-right-length 70


set-option  -g status-left \
"#[bold, bg="${PRIMARY}", fg="${TINT}"] #S "\
"#[fg="${PRIMARY}", bg="${STATUS_BG}"]"


# status-right

set-option -g  status-right \
"#[fg="${COMPLIMENT}", bg="${STATUS_BG}"]"\
"#[bg="${COMPLIMENT}", fg="colour237", bold]#{?client_prefix, Prefix ,}"\
"#[bg="colour237", fg="${PRIMARY}"] %d-%b-%y"\
"#[fg="${TINT1}"] "\
"#[fg="${PRIMARY}", bg=colour239] %H:%M "\
"#[bold, bg="${PRIMARY}",fg=colour237] #H "
