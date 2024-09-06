# vi:ft=tmux

# style attribute
%hidden _URL_PATTERN="\b((https?|ftp|news)://|git@\w+\.\w+:|www[0-9]?\.)[A-Za-z0-9&@#/%$?=~_!.,:;+-]*[A-Za-z0-9&@#/%=~_+-]"

# process checks
# @FIXME: Use regular expression comparison here (fnmatch(3)).
%hidden IS_VIM="ps -o state= -o comm= -t #{pane_tty} | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
%hidden IS_BASH="ps -o comm= -t #{pane_tty} | grep -q bash"
%hidden IS_TIG="ps -o comm= -t #{pane_tty} | grep -q tig"

%hidden _IS_FZF="ps -o comm= -t #{pane_tty} | grep -q fzf"
%hidden _IS_VIM="ps -o state= -o comm= -t #{pane_tty} | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

%hidden _IS_WHIPTAIL="ps -o comm= -t #{pane_tty} | grep -q whiptail"

%hidden IS_FZF="#{==:#{pane_current_command},fzf}"
%hidden IS_VIM="#{m:*vim,#{pane_current_command}}"
%hidden IS_SHELL="#{m:*sh,#{pane_current_command}}"
%hidden IS_TIG="#{==:#{pane_current_command},tig}"
