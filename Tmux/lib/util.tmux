# vi:ft=tmux

# process checks
%hidden IS_FZF="ps -o comm= -t #{pane_tty} | grep -q fzf"
%hidden IS_VIM="ps -o state= -o comm= -t #{pane_tty} | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
%hidden IS_BASH="ps -o comm= -t #{pane_tty} | grep -q bash"

# style attribute
%hidden reset="#[pop-default default]"
