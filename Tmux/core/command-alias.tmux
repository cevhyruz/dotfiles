# vi:ft=tmux

set-option -ag command-alias split-pane="split-window"
set-option -ag command-alias splitp="split-window"
set-option -ag command-alias server-info="show-messages -JT"
set-option -ag command-alias info="show-messages -JT"

# choose-window and choose-session should use a format.
set-option -ag command-alias choose-tree="choose-tree -F'#{E:_window_tree_format}'"
set-option -ag command-alias choose-window="choose-tree -F'#{E:_window_tree_format}' -w"
set-option -ag command-alias choose-session="choose-tree -F'#{E:_window_tree_format}' -s"
set-option -ag command-alias choose-buffer="choose-buffer -F'#{E:_window_buffer_format}'"

# everything should spawn from current working directory.
set-option -ag command-alias vsplit="split-window -hc '#{pane_current_path}'"
set-option -ag command-alias split="split-window -vc '#{pane_current_path}'"
set-option -ag command-alias popup="display-popup -EE -d '#{pane_current_path}'"
set-option -ag command-alias neww="new-window -c '#{pane_current_path}'"

set-option -ag command-alias reload="source-file ${DOT_TMUX}/tmux.conf"
set-option -ag command-alias alias='display-message "#{version}"'
set-option -ag command-alias version='display-message "#{version}"'
set-option -ag command-alias checkhealth='display-message "#{version}"'
