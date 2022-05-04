# vi:ft=tmux

set-option -g command-alias[0] split-pane=split-window
set-option -g command-alias[1] splitp=split-window
set-option -g command-alias[2] "server-info=show-messages -JT"
set-option -g command-alias[3] "info=show-messages -JT"

# choose-window and choose-session should use a format.
set-option -g command-alias[4] "choose-tree -F'#{E:_window_tree_format}'"
set-option -g command-alias[5] "choose-window=choose-tree -F'#{E:_window_tree_format}' -w"
set-option -g command-alias[6] "choose-session=choose-tree -F'#{E:_window_tree_format}' -s"

# everything should spawn from current working directory.
set-option -g command-alias[39] split="split-window -vc '#{pane_current_path}'"
set-option -g command-alias[7]  vsplit="split-window -hc '#{pane_current_path}'"
set-option -g command-alias[9]  popup="display-popup -d '#{pane_current_path}'"
set-option -g command-alias[10] neww="new-window -c '#{pane_current_path}'"

set-option command-alias[97] reload=\
"source-file ${DOT_TMUX}/tmux.conf"

set-option -g command-alias[13] alias='display-message "#{version}"'

set-option -g command-alias[22] statusline=\
"display "

set-option -g command-alias[33] version='display-message "#{version}"'

set-option -g command-alias[43] checkhealth='display-message "#{version}"'
