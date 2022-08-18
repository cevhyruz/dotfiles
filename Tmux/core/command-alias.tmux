# vi:ft=tmux

# custom format for choose-* commands.
set-option -g command-alias[4] choose-window="choose-tree -F'#{E:_window_tree_format}' -wZ"
set-option -g command-alias[5] choose-session="choose-tree -F'#{E:_window_tree_format}' -sZ"
set-option -g command-alias[6] choose-tree="choose-tree -F'#{E:_window_tree_format}' -K'#{E:_window_tree_key_format}' -Z"
set-option -g command-alias[7] choose-buffer="choose-buffer -F'#{E:_window_buffer_format}' -K'#{E:_window_tree_key_format}' -Z"

# everything should spawn from current working directory.
set-option -g command-alias[8] vsplit="split-window -hc '#{pane_current_path}'"
set-option -g command-alias[9] split="split-window -vc '#{pane_current_path}'"
set-option -g command-alias[10] popup="display-popup -EE -d '#{pane_current_path}'"
set-option -g command-alias[11] neww="new-window -c '#{pane_current_path}'"
set-option -g command-alias[12] reload="source-file ${DOT_TMUX}/tmux.conf"
set-option -g command-alias[13] alias='display-message "#{version}"'
set-option -g command-alias[14] version='display-message "#{version}"'
set-option -g command-alias[15] checkhealth='display-message "#{version}"'

set-option -g command-alias[16] set-theme=\
'command-prompt -p "(theme):" { '\
'  set-option -s @theme "%%";'\
'  source-file ${DOT_TMUX}/tmux.conf;'\
'}'


# change background-color of the current-window
set-option -g command-alias[16] color=\
'display "#{window_index}"'
