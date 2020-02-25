# ------------------------------------------------------------------
# Aesthetics
# ------------------------------------------------------------------

# Color Variables.
tmx_status_bg=colour236
tmx_status_fg=colour249
tmx_color_primary=colour30
tmx_color_secondary=colour23
# FIXME: colors should depend on term background.
tmx_term_bg=colour233
tmx_term_bg_active=colour234
tmx_status_git='/home/devs/Projects/dotfiles/tmux'


# Terminal title.

set -g pane-border-status off
set -g pane-border-style 'bg=colour237'
set -ag pane-border-style 'fg=colour237'
# set -g pane-border-format '#[fg=colour23]|          #{pane_title}          |'

set -g pane-active-border-style 'bg=colour237'
set -ag pane-active-border-style 'fg=colour239'

# ------------------------------------------------------------------
# Statusbar
# ------------------------------------------------------------------
set -g  status-position      bottom
set -g  status-justify       centre
set -g  status-right-length  70
set -g  status-left-length   90
set -g  status-bg            $tmx_status_bg
set -g  status-fg            $tmx_status_fg

set -g @stl-sepR ' : '

# set -g status-right-style 'bg=red, fg=yellow'

set -g  status-right   "#(git stream)"
set -ag status-right   " #{@stl-sepR} "
set -ag status-right   " %a / %h-%d"
set -ag status-right   " #{@stl-sepR} "
set -ag status-right   " %l:%M %p"

# status left
# set -g  status-left-bg    $tmx_status_bg
# set -g  status-left-fg    $tmx_status_fg
# set -g  status-left-attr  dim
set -g  status-left       " #[dim]  #S#[dim] [#(tmux list-session | wc -l)] :"

# remove whitespace separator
# set -u window-status-separator ''

# window status
# setw -g window-status-fg     $tmx_status_fg
# setw -g window-status-bg     $tmx_status_bg
# setw -g window-status-attr   dim

set-option -g @_SIMPLE_WINDOW_BG colour234
set-option -g @_SIMPLE_WINDOW_FG colour234

setw -g window-status-format   {
#[fg=colour155,bold]
  #I
#[fg=#{@_SIMPLE_WINDOW_FG},bold]
[
 #W (#{window_panes})
#[fg=colour240]]
}

# current window.
# setw -g window-status-current-fg     $tmx_status_fg
# setw -g window-status-current-bg     $tmx_term_bg_active
# setw -g window-status-current-attr   default

set-option -g @_SIMPLE_CURRENT_WINDOW_BG colour23
set-option -g @_SIMPLE_CURRENT_WINDOW_FG colour155

setw -g window-status-current-format {
#[fg=colour155,bg=#{@_TMUX_CURRENT_WINDOW_BG}]
  #I
#[fg=colour255,bg=#{@_TMUX_CURRENT_WINDOW_BG},bold]
 #W (#{window_panes}) #[fg=colour240,bold]
}

# windows style.
setw -g window-active-style 'bg=colour235'
setw -g window-style        'bg=colour234'

# Clock
setw -g clock-mode-colour $tmx_color_primary
set -g clock-mode-style   12

# Modes.
# setw -g mode-attr default
# setw -g mode-fg   $tmx_status_fg
# setw -g mode-bg   $tmx_color_secondary

# `display-panes` number colour.
set -g display-panes-colour        $tmx_status_fg
set -g display-panes-active-colour $tmx_color_primary

# Panes border.
# set -g pane-border-bg        $tmx_term_bg
# set -g pane-border-fg        $tmx_term_bg_active
# set -g pane-active-border-bg $tmx_term_bg
# set -g pane-active-border-fg $tmx_color_secondary

# Messages and Command mode.
# set -g message-attr default
# set -g message-fg   colour215
# set -g message-bg   colour235
