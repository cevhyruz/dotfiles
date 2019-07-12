# these keybindings uses command-aliases

bind-key -T prefix r reload
bind-key -T prefix c tabnew

# window splits
bind-key -T prefix %  vsplit
bind-key -T prefix \; hsplit

# programs & executables.
# bind-key -T prefix n ftpane
# bind-key -T prefix m ftsession
# bind-key -T prefix v vifm
bind-key -T prefix h htop


###### repeatable keys ######

# pane resizing.
bind-key -rT prefix H resizep -L 1
bind-key -rT prefix L resizep -R 1
bind-key -rT prefix J resizep -D 1
bind-key -rT prefix K resizep -U 1

# slightly faster pane resizing.
bind-key -rT prefix < resizep -L 2
bind-key -rT prefix > resizep -R 2


## switching client ##
bind-key -T prefix m switch-client -T navigate
bind-key -T prefix m switch-client -T navigate
