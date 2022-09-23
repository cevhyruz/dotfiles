# vi:ft=tmux
# ---------------------------------------------------------------------------
# File:        powerline.tmux
# Colorscheme: monochromatic
# Type:        two lined statusbar,dark, powerline
# ---------------------------------------------------------------------------

# [!] changing STATUS_BG color of pane is not possible until 2.1
# [!] format modifiers to expand a format twice (T:, E:) is not available until 3.0
# [!] status-format is not available until 2.9
# [!] TrueColors will be available at 2.2
# [!] %hidden is not available until 3.2

# https://gist.github.com/sindresorhus/bed863fb8bedf023b833c88c322e44f9
# Color Pallete
# Monochromatic is a single Hue / base
# shades and/or tones - darker color
# tint - ligther color
# Compatible tmux => 1.9
# atleast 2.0

# themes should only consists of options.

%hidden PRIMARY="colour252" # >________<
%hidden COMPLIMENT="yellow"
%hidden BACKGROUND="colour235" # should be opposite of primary, for contrast
%hidden TINT="black"
%hidden TINT1="colour234"
%hidden TINT2="colour243"

%hidden STATUS_BG="colour235"
%hidden WINDOW_STATUS_BG="colour236"
%hidden WINDOW_STATUS_CURRENT_BG="colour237"
%hidden WINDOW_STATUS_CURRENT_FG=${PRIMARY}

set-option -g status on
set-option -g message-style "fg=colour248,bg="${TINT1}""

set-option -g status-position "bottom"
set-option -g status-justify "left"

set-option -g display-panes-time 5000
set-option -g display-panes-active-colour yellow
set-option -g display-panes-colour        ${PRIMARY}

set-option -g status-bg "${STATUS_BG}"
set-option -g status-fg "${PRIMARY}"

set-window-option -g clock-mode-style 12
set-window-option -g clock-mode-colour ${TINT2}

set-option -g renumber-windows on
set-option -g base-index 1

if-shell -b '[ "$(echo "$TMUX_VERSION >= 2.1" | bc)" = 1 ]' \
"  set-option -g window-style        "bg=${STATUS_BG}";        \
   set-option -g window-active-style "bg=${WINDOW_STATUS_BG}"; \
"

set-window-option -g window-status-separator ""

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

set-option -g status-right-style default
set-option -g status-right-length 70
set-option -g  status-right \
"#[fg=cyan,bg="${STATUS_BG}"]\uf012 #[fg=colour246]${wifi} "\
"#[fg=cyan]#[fg="colour237"]"\
"#[bg="colour237",fg="${PRIMARY}"] %d-%b-%y"\
" #[fg=cyan]#[fg="${TINT1}"]"\
"#[fg="cyan",bg="${TINT1}"] %I:%M %p #[fg="${PRIMARY}"]"\
"#[bg="${PRIMARY}",fg="${TINT1}"] #h "

set-option -g status-left-style default
set-option -g status-left-length  70
set-option -g status-left \
"#[bg="${PRIMARY}",fg="${TINT}"] #{b:socket_path}:#S "\
"#[fg="${PRIMARY}",bg="colour237"]#[fg=cyan]\ue0b1"\
"#[fg="${PRIMARY}",bg=colour237] #{s/#{HOME}/~:#{pane_current_path}} "\
"#[fg=colour237,bg="${STATUS_BG}"]#[fg=cyan]\ue0b1"

#set-option -g status-format[0] \
#"#[align=left range=left #{E:status-left-style}]#[push-default]#{T;=/#{status-left-length}:status-left}#[pop-default]"\
#"#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{E:window-status-current-style},default},#{E:window-status-current-style},#{E:window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}"\
#"#[nolist align=right range=right #{E:status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]"
