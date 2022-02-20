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

# Theme Options
set-option -g status on
set-option -g message-style "fg=colour248,bg="${TINT1}""

set-option -g status-position "bottom"
set-option -g status-justify "centre"

set-option -g display-panes-time 5000
set-option -g display-panes-active-colour yellow
set-option -g display-panes-colour        ${PRIMARY}

set-option -g status-bg "${STATUS_BG}"
set-option -g status-fg "${PRIMARY}"

set-window-option -g clock-mode-style 12
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
"#[bg="${TINT1}", fg="${STATUS_BG}"] "\
"#[fg="${COMPLIMENT}"]#I:"\
"#[fg="colour244", bg="${TINT1}"] #W "\
"#[fg="${PRIMARY}"]#F "\
"#[bg="${STATUS_BG}", fg="${TINT1}"]"

set-window-option -g window-status-format \
"#[bg="${WINDOW_STATUS_BG}", fg="${STATUS_BG}"]"\
"#[bg="${WINDOW_STATUS_BG}", fg="${COMPLIMENT}"] #I:"\
"#[fg="${PRIMARY}"] #W "\
"#[fg="white"]#{?#{==:#F,}, ,#F} "\
"#[fg="${WINDOW_STATUS_BG}", bg="${STATUS_BG}"]"

# [!] status-format is not available until 2.9
# status-left
set-option -g status-left-length  70

set-option -g status-left \
"#[bg="${PRIMARY}",fg="${TINT}"] #{b:socket_path}:#S "\
"#[fg="${PRIMARY}",bg="colour237"]#[fg=cyan]\ue0b1"\
"#[fg="${PRIMARY}",bg=colour237] #{pane_current_path} "\
"#[fg=colour237,bg="${STATUS_BG}"]#[fg=cyan]\ue0b1"


# status-right
set-option -g status-right-length 70

set-option -g  status-right \
"#[fg=cyan,bg="${STATUS_BG}"]\uf012 #[fg=colour246]${wifi} "\
"#[fg=cyan]#[fg="colour237"]"\
"#[bg="colour237",fg="${PRIMARY}"] %d-%b-%y"\
" #[fg=cyan]#[fg="${TINT1}"]"\
"#[fg="cyan",bg="${TINT1}"] %I:%M %p #[fg="${PRIMARY}"]"\
"#[bg="${PRIMARY}",fg="${TINT1}"] #h "

#set-option -g status-format[0] "#{E:#{status-left}#[align=right]#{status-right}}"

#set-option -g status-format[1] \
#"#[bold,fg=cyan] -#[default,fg=colour246] %I:%M %p #[bold,fg=cyan]-"\
#"#[default,align=centre]#{W:#{E:window-status-format},#{E:window-status-current-format}}"\
#"#[align=right]#[bold,fg=cyan] - #[default,fg=colour246]current playing song #[bold,fg=cyan]- "\
