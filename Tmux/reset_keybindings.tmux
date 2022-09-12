# vi:ft=tmux fdm=marker

# default tmux v3.3 keybindings.

# prefix keys
bind -N 'Send the prefix key' C-b { send-prefix }
bind -N 'Rotate through the panes' C-o { rotate-window }
bind -N 'Suspend the current client' C-z { suspend-client }
bind -N 'Select next layout' Space { next-layout }
bind -N 'Break pane to a new window' ! { break-pane }
bind -N 'Split window vertically' '"' { split-window }
bind -N 'List all paste buffers' '#' { list-buffers }
bind -N 'Rename current session' '$' { command-prompt -I'#S' { rename-session -- '%%' } }
bind -N 'Split window horizontally' % { split-window -h }
bind -N 'Kill current window' & { confirm-before -p "kill-window #W? (y/n)" kill-window }
bind -N 'Prompt for window index to select' "'" { command-prompt -T window-target -pindex { select-window -t ':%%' } }
bind -N 'Switch to previous client' ( { switch-client -p },
bind -N 'Switch to next client' ) { switch-client -n },
bind -N 'Rename current window' , { command-prompt -I'#W' { rename-window -- '%%' } }
bind -N 'Delete the most recent paste buffer' - { delete-buffer }
bind -N 'Move the current window' . { command-prompt -T target { move-window -t '%%' } }
bind -N 'Describe key binding' '/' { command-prompt -kpkey  { list-keys -1N '%%' } }
bind -N 'Select window 0' 0 { select-window -t:=0 }
bind -N 'Select window 1' 1 { select-window -t:=1 }
bind -N 'Select window 2' 2 { select-window -t:=2 }
bind -N 'Select window 3' 3 { select-window -t:=3 }
bind -N 'Select window 4' 4 { select-window -t:=4 }
bind -N 'Select window 5' 5 { select-window -t:=5 }
bind -N 'Select window 6' 6 { select-window -t:=6 }
bind -N 'Select window 7' 7 { select-window -t:=7 }
bind -N 'Select window 8' 8 { select-window -t:=8 }
bind -N 'Select window 9' 9 { select-window -t:=9 }
bind -N 'Prompt for a command' : { command-prompt }
bind -N 'Move to the previously active pane' ';' { last-pane }
bind -N 'Choose a paste buffer from a list' = { choose-buffer -Z }
bind -N 'List key bindings' ? { list-keys }
bind -N 'Choose a client from a list' D { choose-client -Z }
bind -N 'Spread panes out evenly' E { select-layout -E }
bind -N 'Switch to the last client' L { switch-client -l }
bind -N 'Clear the marked pane' M { select-pane -M }
bind -N 'Enter copy mode' [ { copy-mode }
bind -N 'Paste the most recent paste buffer' ] { paste-buffer -p }
bind -N 'Create a new window' c { new-window }
bind -N 'Detach the current client' d { detach-client }
bind -N 'Search for a pane' f { command-prompt { find-window -Z -- '%%' } }
bind -N 'Display window information' i { display-message }
bind -N 'Select the previously current window' l { last-window }
bind -N 'Toggle the marked pane' m { select-pane -m }
bind -N 'Select the next window' n { next-window }
bind -N 'Select the next pane' o { select-pane -t:.+ }
bind -N 'Customize options' C { customize-mode -Z }
bind -N 'Select the previous window' p { previous-window }
bind -N 'Display pane numbers' q { display-panes }
bind -N 'Redraw the current client' r { refresh-client }
bind -N 'Choose a session from a list' s { choose-tree -Zs }
bind -N 'Show a clock' t { clock-mode }
bind -N 'Choose a window from a list' w { choose-tree -Zw }
bind -N 'Kill the active pane' x { confirm-before -p"kill-pane #P? (y/n)" kill-pane }
bind -N 'Zoom the active pane' z { resize-pane -Z }
bind -N 'Swap the active pane with the pane above' '{' { swap-pane -U }
bind -N 'Swap the active pane with the pane below' '}' { swap-pane -D }
bind -N 'Show messages' '~' { show-messages }
bind -N 'Enter copy mode and scroll up' PPage { copy-mode -u }
bind -N 'Select the pane above the active pane' -r Up { select-pane -U }
bind -N 'Select the pane below the active pane' -r Down { select-pane -D }
bind -N 'Select the pane to the left of the active pane' -r Left { select-pane -L }
bind -N 'Select the pane to the right of the active pane' -r Right { select-pane -R }
bind -N 'Set the even-horizontal layout' M-1 { select-layout even-horizontal }
bind -N 'Set the even-vertical layout' M-2 { select-layout even-vertical }
bind -N 'Set the main-horizontal layout' M-3 { select-layout main-horizontal }
bind -N 'Set the main-vertical layout' M-4 { select-layout main-vertical }
bind -N 'Select the tiled layout' M-5 { select-layout tiled }
bind -N 'Select the next window with an alert' M-n { next-window -a }
bind -N 'Rotate through the panes in reverse' M-o { rotate-window -D }
bind -N 'Select the previous window with an alert' M-p { previous-window -a }
bind -N 'Move the visible part of the window up' -r S-Up { refresh-client -U 10 }
bind -N 'Move the visible part of the window down' -r S-Down { refresh-client -D 10 }
bind -N 'Move the visible part of the window left' -r S-Left { refresh-client -L 10 }
bind -N 'Move the visible part of the window right' -r S-Right { refresh-client -R 10 }
bind -N 'Reset so the visible part of the window follows the cursor' -r DC { refresh-client -c }
bind -N 'Resize the pane up by 5' -r M-Up { resize-pane -U 5 }
bind -N 'Resize the pane down by 5' -r M-Down { resize-pane -D 5 }
bind -N 'Resize the pane left by 5' -r M-Left { resize-pane -L 5 }
bind -N 'Resize the pane right by 5' -r M-Right { resize-pane -R 5 }
bind -N 'Resize the pane up' -r C-Up { resize-pane -U }
bind -N 'Resize the pane down' -r C-Down { resize-pane -D }
bind -N 'Resize the pane left' -r C-Left { resize-pane -L }
bind -N 'Resize the pane right' -r C-Right { resize-pane -R }

# Copy mode (vi) keys.
bind -T copy-mode-vi '#' { send -FX search-backward '#{copy_cursor_word}' }
bind -T copy-mode-vi * { send -FX search-forward '#{copy_cursor_word}' }
bind -T copy-mode-vi C-c { send -X cancel }
bind -T copy-mode-vi C-d { send -X halfpage-down }
bind -T copy-mode-vi C-e { send -X scroll-down }
bind -T copy-mode-vi C-b { send -X page-up }
bind -T copy-mode-vi C-f { send -X page-down }
bind -T copy-mode-vi C-h { send -X cursor-left }
bind -T copy-mode-vi C-j { send -X copy-pipe-and-cancel }
bind -T copy-mode-vi Enter { send -X copy-pipe-and-cancel }
bind -T copy-mode-vi C-u { send -X halfpage-up }
bind -T copy-mode-vi C-v { send -X rectangle-toggle }
bind -T copy-mode-vi C-y { send -X scroll-up }
bind -T copy-mode-vi Escape { send -X clear-selection }
bind -T copy-mode-vi Space { send -X begin-selection }
bind -T copy-mode-vi '$' { send -X end-of-line }
bind -T copy-mode-vi , { send -X jump-reverse }
bind -T copy-mode-vi / { command-prompt -T search -p'(search down)' { send -X search-forward '%%' } }
bind -T copy-mode-vi 0 { send -X start-of-line }
bind -T copy-mode-vi 1 { command-prompt -Np'(repeat)' -I1 { send -N '%%' } }
bind -T copy-mode-vi 2 { command-prompt -Np'(repeat)' -I2 { send -N '%%' } }
bind -T copy-mode-vi 3 { command-prompt -Np'(repeat)' -I3 { send -N '%%' } }
bind -T copy-mode-vi 4 { command-prompt -Np'(repeat)' -I4 { send -N '%%' } }
bind -T copy-mode-vi 5 { command-prompt -Np'(repeat)' -I5 { send -N '%%' } }
bind -T copy-mode-vi 6 { command-prompt -Np'(repeat)' -I6 { send -N '%%' } }
bind -T copy-mode-vi 7 { command-prompt -Np'(repeat)' -I7 { send -N '%%' } }
bind -T copy-mode-vi 8 { command-prompt -Np'(repeat)' -I8 { send -N '%%' } }
bind -T copy-mode-vi 9 { command-prompt -Np'(repeat)' -I9 { send -N '%%' } }
bind -T copy-mode-vi : { command-prompt -p'(goto line)' { send -X goto-line '%%' } }
bind -T copy-mode-vi ';' { send -X jump-again }
bind -T copy-mode-vi ? { command-prompt -T search -p'(search up)' { send -X search-backward '%%' } }
bind -T copy-mode-vi A { send -X append-selection-and-cancel }
bind -T copy-mode-vi B { send -X previous-space }
bind -T copy-mode-vi D { send -X copy-pipe-end-of-line-and-cancel }
bind -T copy-mode-vi E { send -X next-space-end }
bind -T copy-mode-vi F { command-prompt -1p'(jump backward)' { send -X jump-backward '%%' } }
bind -T copy-mode-vi G { send -X history-bottom }
bind -T copy-mode-vi H { send -X top-line }
bind -T copy-mode-vi J { send -X scroll-down }
bind -T copy-mode-vi K { send -X scroll-up }
bind -T copy-mode-vi L { send -X bottom-line }
bind -T copy-mode-vi M { send -X middle-line }
bind -T copy-mode-vi N { send -X search-reverse }
bind -T copy-mode-vi P { send -X toggle-position }
bind -T copy-mode-vi T { command-prompt -1p'(jump to backward)' { send -X jump-to-backward '%%' } }
bind -T copy-mode-vi V { send -X select-line }
bind -T copy-mode-vi W { send -X next-space }
bind -T copy-mode-vi X { send -X set-mark }
bind -T copy-mode-vi ^ { send -X back-to-indentation }
bind -T copy-mode-vi b { send -X previous-word }
bind -T copy-mode-vi e { send -X next-word-end }
bind -T copy-mode-vi f { command-prompt -1p'(jump forward)' { send -X jump-forward '%%' } }
bind -T copy-mode-vi g { send -X history-top }
bind -T copy-mode-vi h { send -X cursor-left }
bind -T copy-mode-vi j { send -X cursor-down }
bind -T copy-mode-vi k { send -X cursor-up }
bind -T copy-mode-vi l { send -X cursor-right }
bind -T copy-mode-vi n { send -X search-again }
bind -T copy-mode-vi o { send -X other-end }
bind -T copy-mode-vi q { send -X cancel }
bind -T copy-mode-vi r { send -X refresh-from-pane }
bind -T copy-mode-vi t { command-prompt -1p'(jump to forward)' { send -X jump-to-forward '%%' } }
bind -T copy-mode-vi v { send -X rectangle-toggle }
bind -T copy-mode-vi w { send -X next-word }
bind -T copy-mode-vi '{' { send -X previous-paragraph }
bind -T copy-mode-vi '}' { send -X next-paragraph }
bind -T copy-mode-vi % { send -X next-matching-bracket }
bind -T copy-mode-vi MouseDown1Pane { select-pane }
bind -T copy-mode-vi MouseDrag1Pane { select-pane; send -X begin-selection }
bind -T copy-mode-vi MouseDragEnd1Pane { send -X copy-pipe-and-cancel }
bind -T copy-mode-vi WheelUpPane { select-pane; send -N5 -X scroll-up }
bind -T copy-mode-vi WheelDownPane { select-pane; send -N5 -X scroll-down }
bind -T copy-mode-vi DoubleClick1Pane { select-pane; send -X select-word; run -d0.3; send -X copy-pipe-and-cancel }
bind -T copy-mode-vi TripleClick1Pane { select-pane; send -X select-line; run -d0.3; send -X copy-pipe-and-cancel }
bind -T copy-mode-vi BSpace { send -X cursor-left }
bind -T copy-mode-vi NPage { send -X page-down }
bind -T copy-mode-vi PPage { send -X page-up }
bind -T copy-mode-vi Up { send -X cursor-up }
bind -T copy-mode-vi Down { send -X cursor-down }
bind -T copy-mode-vi Left { send -X cursor-left }
bind -T copy-mode-vi Right { send -X cursor-right }
bind -T copy-mode-vi M-x { send -X jump-to-mark }
bind -T copy-mode-vi C-Up { send -X scroll-up }
bind -T copy-mode-vi C-Down { send -X scroll-down }
