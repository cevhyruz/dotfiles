# vi:ft=tmux fdm=marker
# ---------------------------------------------------------------------------
# File:        setup.tmux
# Description: setup necesarry things for tmux accordingly
# --------------------------------------------------------------------------

# Theme Bootstrapper
%if "#{!=:#{@theme},''}"
  source-file -F "${TMUX_THEME_DIR}/#{@theme}/*.tmux"
%else
  source-file "${TMUX_THEME_DIR}/powerliner/*.tmux"
%endif

# Terminfo
%if "#{m:*256col*,#{default-terminal}}"
  set-option -as terminal-overrides \
',*:RGB:Smulx=\E[4::%p1%dm:Smol=\E[53m:smxx=\E[9m'\
',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
%endif

# Prefix keys
if-shell -F "#{||:#{!=:#{prefix},C-b},#{!=:#{prefix2},None}}" {
  run-shell -b {
    tmux bind -T prefix -N "Send prefix key on consecutive hits" \
    "$(tmux show-options -gvq prefix)" send-prefix;

    tmux bind-key -T prefix2 -N "Send prefix2 key on consecutive hits" \
    "$(tmux show-option -gvq prefix2)" send-prefix -2;
  }
}

# Remove unused mode keys.
run-shell -b {
  tmux unbind-key -aT \
    "#{?#{==:#{mode-keys},vi},copy-mode,copy-mode-vi}" &> /dev/null;
}

# mouse keybindings
%if "#{mouse}"
  unbind -T copy-mode-vi MouseDragEnd1Pane
%endif

# Local Config

%if "#{!=:#{@extra-config},}"
  run-shell -b { tmux source-file "#{@extra-config}" }
%endif

# Extra config file
set-hook -ag after-new-session {
  %if "#{!=:#{@extra-config},}"
    run-shell -b { tmux source-file "#{@extra-config}" }
  %endif
}

# Change session number to 1 instead of 0.
set-hook -ag after-new-session {
  if-shell -F "#{m/r:^[0-9]$,#{session_name}}" {
    run-shell -b { tmux rename-session "$(tmux list-sessions | wc -l)" }
  }
}
