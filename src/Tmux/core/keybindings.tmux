# vi:ft=tmux fdm=marker

unbind -aT prefix
%if "#{==:#{mode-keys},vi}"
  unbind -aqT copy-mode
%endif

# Prefix keys
bind-key -N "Send the prefix key" ` { send-prefix }
bind-key -N "Resize the pane to right" -r '>' { resize-pane -R }
bind-key -N "Resize the pane to left" -r '<' { resize-pane -L }
bind-key -N "Resize the pane downward" -r 'J' { resize-pane -D }
bind-key -N "Resize the pane upward" -r 'K' { resize-pane -U }
bind-key -N "Show messages" '~' { show-messages }
bind-key -N "Swap the active pane with the pane above" '{' { swap-pane -U }
bind-key -N "Swap the active pane with the pane below" '}' { swap-pane -D }
bind-key -N "Zoom the active pane" z { resize-pane -Z }
bind-key -N "Kill the active pane" x { confirm-before -p "kill-pane #P? (y/n)" kill-pane }
bind-key -N "Show a clock" t { clock-mode }
bind-key -N "Display pane numbers" q { display-panes }
bind-key -N "Customize options" C { customize-mode -Z }
bind-key -N "Select the next window with an alert" M-n { next-window -a }
bind-key -N "Select the previous window with an alert" M-p { previous-window -a }
bind-key -N "Detach the current client" d { detach-client }
bind-key -N "Create a new window" c { new-window }
bind-key -N "Paste the most recent paste buffer" ] { paste-buffer -p }
bind-key -N "Enter copy mode" [ { copy-mode }
bind-key -N "Toggle the marked pane" m { select-pane -m }
bind-key -N "Clear the marked pane" M { select-pane -M }
bind-key -N "Prompt for window index to select" "'" { command-prompt -T window-target -pindex { select-window -t ':%%' } }
bind-key -N "Switch to previous client" ( { switch-client -p }
bind-key -N "Switch to next client" ) { switch-client -n }
bind-key -N "Kill current window" & { confirm-before -p"kill-window #W? (y/n)" kill-window }
bind-key -N "Rename current session" '$' { command-prompt -I'#S' { rename-session -- '%%' } }
bind-key -N "List all paste buffers" '#' { list-buffers }
bind-key -N "Break pane to a new window" ! { break-pane }
bind-key -N "Select next layout" Space { next-layout }
bind-key -N "Suspend the current client" C-z { suspend-client }
bind-key -N "Rotate through the panes" C-o { rotate-window }
bind-key -N "Select window 0" 0 { select-window -t:=0 }
bind-key -N "Select window 1" 1 { select-window -t:=1 }
bind-key -N "Select window 2" 2 { select-window -t:=2 }
bind-key -N "Select window 3" 3 { select-window -t:=3 }
bind-key -N "Select window 4" 4 { select-window -t:=4 }
bind-key -N "Select window 5" 5 { select-window -t:=5 }
bind-key -N "Select window 6" 6 { select-window -t:=6 }
bind-key -N "Select window 7" 7 { select-window -t:=7 }
bind-key -N "Select window 8" 8 { select-window -t:=8 }
bind-key -N "Select window 9" 9 { select-window -t:=9 }
bind-key -N "Move the current window" . { command-prompt -T target { move-window -t '%%' } }
bind-key -N "Describe key binding" '/' { command-prompt -kpkey  { list-keys -1N '%%' } }
bind-key -N "Move to the previously active pane" \; { last-pane }
bind-key -N "Choose a client from a list" D { choose-client -Z }
bind-key -N "Spread panes out evenly" E { select-layout -E }
bind-key -N "Switch to the last client" L { switch-client -l }
bind-key -N "Rename current window" , { command-prompt -I'#W' { rename-window -- '%%' } }
bind-key -N "Select the previously current window" l { last-window }
bind-key -N "List key bindings" ? { list-keys -N }
bind-key -N "Select the previous window" 'p' {

if-shell -F "#{e|>:#{session_windows},1}" {
    previous-window
    set-environment -hF _message ""
  } {
    set-environment -hF _message "No previous window"
  }
}

bind-key -N "Select the next window" n {
  if-shell -F "#{e|>:#{session_windows},1}" {
    next-window
    set-environment -hF _message ""
  } {
    set-environment -hF _message "No next window"
  }
}

bind-key -N "Prompt for a command" : {
  command-prompt -p ":"
  set-environment -hF _message ""
}

bind-key -N "Search for URLs in current pane" u {
  copy-mode
  send-keys -X start-of-line
  send-keys -X -F search-forward "#{_URL_PATTERN}"
}

bind-key -N "Choose window from menu" w { choose-tree-menu }
bind-key -N "Choose a session from a list" s { choose-session }
bind-key -N "Choose a paste buffer from a list" = { choose-buffer }
bind-key -N "Open main menu" o { menubar }
bind-key -N "Toggle read-only mode" R { switch-client -r }

bind-key -N "Toggle synchronize pane for all panes in window" y {# {{{
  if-shell -F "#{e|>:#{window_panes},1}" {
    set-window-option synchronize-panes
    set-environment -hF _message "sync is on"
  } {
    set-environment -hF _message "No other panes to sync"
  }
}

bind-key -N "reload and redraw tmux" r {
  refresh-client
  source-file "${DOT_TMUX}/tmux.conf"
  set-environment -hF _message "tmux.conf reloaded"
}

bind-key -N "Split window horizontally" % { split-window -hc "#{pane_current_path}" }
bind-key -N "Split window verticaly" '"' { split-window -vc "#{pane_current_path}" }

# ------------------------------
# Root keys
# ------------------------------

bind-key -N "Go to left pane" -T root C-h {
  refresh-client -S
  if-shell -F "#{E:IS_VIM}" {
    send-keys C-h
  } {
    select-pane -L
  }
  set-environment -hF _message ""
}

bind-key -N "Go to lower pane" -T root  C-j {
  refresh-client -S
  if-shell -F "#{||:#{E:IS_FZF},#{E:IS_VIM}}" {
    send-keys C-j
  } {
    select-pane -D
  }
  set-environment -hF _message ""
}

bind-key -N "Go to upper pane" -T root C-k {
  refresh-client -S
  if-shell -F "#{||:#{E:IS_FZF},#{E:IS_VIM}}" {
    send-keys C-k
  } {
    select-pane -U
  }
  set-environment -hF _message ""
}

bind-key -N "Go to right pane" -T root C-l {
  refresh-client -S
  if-shell -F "#{E:IS_VIM}" {
    send-keys C-l
  } {
    select-pane -R
  }
  set-environment -hF _message ""
}

bind-key -N "Go to previous pane" -T root C-\\ {
  refresh-client -S
  if-shell -F "#{E:IS_VIM}" {
    send-keys C-\\
  } {
    last-pane
  }
}
# ------------------------------
# Copy-mode keys
# ------------------------------


# copy-mode navigation.
bind-key -T copy-mode-vi 'C-h' {
  select-pane -L
  set-environment -hF _message ""
}

bind-key -T copy-mode-vi 'C-j' {
  select-pane -D
  set-environment -hF _message ""
}

bind-key -T copy-mode-vi 'C-k' {
  select-pane -U
  set-environment -hF _message ""
}

bind-key -T copy-mode-vi 'C-l' {
  select-pane -R
  set-environment -hF _message ""
}

bind-key -T copy-mode-vi 'C-\' { select-pane -l }
bind-key -T copy-mode-vi 'i' { send-keys -X cancel }

bind-key -T copy-mode-vi 'n' {
  send-keys -X search-again
}

# Open current match in BROWSER only if it's a valid URL.
bind-key -T copy-mode-vi Enter {
  if-shell -F "#{&&:#{&&:#{search_present},#{search_match}},#{==:#{pane_search_string},#{_URL_PATTERN}}}" {
    # send-keys -X copy-pipe-no-clear 'sed -E "s/^git@(\\w+\\.\\w+):(.*)\$/https:\\/\\/\\1\\/\\2/" | xargs -I {} $BROWSER "{}"'
    # display "opening '#{search_match}' in browser"
    context-menu
  } {
    send-keys -X copy-pipe-and-cancel
    display "yanked '#{search_match}'"
  }
}

bind-key -T copy-mode-vi 'v' {
  set-option -Ug @visual-line
  send-keys -X begin-selection
}

bind-key -T copy-mode-vi 'V' {
  set-option -g @visual-line 1
  send-keys -X select-line
}

bind-key -T copy-mode-vi 'q' {
  set-option -Ug @visual-line
  send-keys -X cancel
}

bind-key -T copy-mode-vi 'C-n' {
  send-keys -X search-again
}

bind-key -T copy-mode-vi 'C-p' {
  send-keys -X search-reverse
}

bind-key -T copy-mode-vi 'C-v' {
  send-keys -X rectangle-toggle
  send-keys -X begin-selection
}

# copy-mode scroll down by 3.
bind-key -T copy-mode-vi 'C-e' {
  send-keys -X -N 3 scroll-down
}

# copy-mode scroll up by 3.
bind-key -T copy-mode-vi 'C-y' {
  send-keys -X -N 3 scroll-up
  if-shell -F "#{selection_active}" {
    send-keys -X -N 3 cursor-down
  }
}

bind-key -N "" -T root 'C-y' {
  if-shell -F "#{E:IS_VIM}" {
    send-keys C-y
  } {
    copy-mode -e
    send-keys -X -N 3 scroll-up
  }
}

# yanking.
bind-key -N "Copy shit" -T copy-mode-vi y {
  if-shell -b "command -v xclip" {
    send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
  } {
    send-keys -X copy-selection
  }
  set-environment -hF _message "yanked #{E:_selection}"
}
