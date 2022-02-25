# vi:ft=tmux

# everything should start from CWD.
set-option -g command-alias[6] split="split-window -vc '#{pane_current_path}'"
set-option -g command-alias[7] vsplit="split-window -hc '#{pane_current_path}'"
set-option -g command-alias[9] popup="display-popup -d '#{pane_current_path}'"
set-option -g command-alias[10] neww="new-window -c '#{pane_current_path}'"


set-option -g command-alias[8] alias=''

set-option command-alias[97] reload=\
"source-file ${DOT_TMUX}/tmux.conf"
