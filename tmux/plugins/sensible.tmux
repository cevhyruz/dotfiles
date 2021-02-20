# vi:ft=tmux fdm=marker
# ---------------------------------------------------------------------------
# File:        sensible.tmux
# Description: sensible tmux configuration
# --------------------------------------------------------------------------

# Terminfo
#%if "#{m:*256col*,#{default-terminal}}"
  #set-option -as terminal-overrides \
#',*:RGB:Smulx=\E[4::%p1%dm:Smol=\E[53m:smxx=\E[9m'\
#',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
#%endif

# mouse keybindings
#%if "#{mouse}"
  #unbind -T copy-mode-vi MouseDragEnd1Pane
#%endif

# Extra config file
#set-hook -ag after-new-session {
  #if-shell -F "#{!=:#{@extra-config},}" {
    #run-shell -b { tmux source-file "#{@extra-config}" &> /dev/null; }
  #}
#}

# Change session number to 1 instead of 0.
#set-hook -ag after-new-session {
  #if-shell -F "#{m/r:^[0-9]$,#{session_name}}" {
    #run-shell -b { tmux rename-session "$(tmux list-sessions | wc -l)" }
  #}
#}
