# alias[0-5]  - tmux predefined alias
# alias[6-10] - for temporary alias.

display "aliases"
# TODO: Please remove this variables! it's cluttering the env.
# programs and scripts status.
is_gslive=" ps -o command --tty '#{pane_tty}' | grep --silent 'gslive' "
   is_fzf=" ps -o command --tty '#{pane_tty}' | grep --silent 'fzf' "
   is_vim=" ps -o command --tty '#{pane_tty}' | grep --silent 'vim' "
  is_vifm=" ps -o command --tty '#{pane_tty}' | grep --silent 'vifm' "
  is_htop=" ps -o command --tty '#{pane_tty}' | grep --silent 'htop' "
  is_bash=" ps -o comm --tty '#{pane_tty}' | tail -1 | grep -q 'bash' "

set -s command-alias[34] proclist='run-shell "ps -o command --tty #{pane_tty}"'

# split positions (lines / cells).
lowermost=" -fvl  "
      bot=" -fvl  "
 leftmost=" -fhbl "
rightmost=" -fhl  "


set -s command-alias[85] command-prompt={
  # display-message 'yow command prompt'
  run;

}

set -s command-alias[35] command={
  display-message 'my commando'
}
# ------------------------------------------------------------------
# navigation (vim and fzf aware)
# ------------------------------------------------------------------
# [?] goto upper pane.
# set -s command-alias[10] \
   up='run -b "( $is_vim && tmux send C-k ) || \
                 ( $is_fzf && tmux send C-k ) || \
                   tmux select-pane -U "'

# [?] goto upper pane.
set -s command-alias[10] up={
  run -b "( $is_vim && tmux send C-k ) || \
          ( $is_fzf && tmux send C-k ) || \
            tmux select-pane -U"
}


# [?] goto lower pane
set -s command-alias[11] \
   down='run -b "( $is_vim && tmux send C-j ) || \
                 ( $is_fzf && tmux send C-j ) || \
                   tmux select-pane -D "'

# [?] goto left-side pane.
set -s command-alias[12] \
   left='run -b "( $is_vim && tmux send C-h ) || \
                   tmux selectp -L "'

# [?] goto right-side pane.
set -s command-alias[13] \
  right='run -b "( $is_vim && tmux send C-l ) || \
                   tmux selectp -R"'

# [?] goto last active pane.
set -s command-alias[14] lastpane='if "$is_vim" "send C-\\" "last-pane"'

# ------------------------------------------------------------------
# To simulate visual-select in bash readline
# ------------------------------------------------------------------
# if bash;
  # only trigger command when readline is in normal mode
  # add common vim motion/word operators
  # disable up & down navigation
  # stop selection if start/end of the line
  # adjust/simulate virtual edit (exclue prompt symbol: $)
set -s command-alias[84] \
visual='if "$is_bash" \
       "copy-mode; send-keys -X begin-selection" \
       "send-key -l v"'

# ------------------------------------------------------------------
# Common vim-like operators and motion
# ------------------------------------------------------------------

# -----------------------------------------------------------------r
# programs & executable scripts.
# ------------------------------------------------------------------
set -s command-alias[15] \
   ftpane='if "( $is_fzf && tmux send C-c ) || \
               ( command -v 'ftpane' && tmux splitw $bot 8 'ftpane' )" '' \
               " $err404 "'

set -s command-alias[16] \
ftsession='if "( $is_fzf && tmux send C-c ) || \
               ( command -v 'ftsession' && tmux splitw $bot 8 'ftsession' )" '' \
               " $err404 "'

set -s command-alias[17] \
  gslive='if "( tmux show-env GSLIVE && tmux send C-c )" || \
             " tmux set-env -u GSLIVE " \
             " tmux splitw $rightmost 40 'gslive'"  '

# set -s command-alias[17] \
#    gslive='if "( $is_gslive && tmux send C-c ) || \
#                ( command -v 'gslive' && tmux splitw $rightmost 40 'gslive' )" '' \
#                " $err404 "'

set -s command-alias[18] \
     vifm='if "( $is_vifm && tmux send :q Enter ) || \
               ( command -v 'vifm' && tmux splitw $leftmost 35 'vifm' )" '' \
               " $err404 "'

set -s command-alias[19] \
     htop='if "( $is_htop && tmux send q ) || \
               ( command -v 'htop' && tmux splitw $bot 5 'htop' )" ''\
               " $err404 "'

set -s command-alias[34] \
     proclist='run-shell "ps -o command --tty #{pane_tty}"'


set -s command-alias[50] \
  myshell='bash'

# ------------------------------------------------------------------
# tmux commands
# ------------------------------------------------------------------
# [?] reload tmux configuration file.
set -s command-alias[20] \
    reload='run "tmux source-file /etc/tmux.conf; tmux display \" config file reloaded\""'

# there's 2 way to save history:
# 1. by appending it to user-option. (maybe has some perfomance overhead)
# 2. by writing it to a file. (shell compliant)
# [?] command-prompt with history.
set -s command-alias[6] \
cmd="command-prompt -p '$:' 'run \"tmux set -sa @history %%; tmux %1\" '"

# [?] create new window with specified path.
# input: [target dir] [shell-command]
set -s command-alias[21] \
tabnew="command-prompt -p '[new window]: ' \
           'neww -c '%%'; setw @window_current_path '%1' '"

# [?] set window default path for new panes.
set -s command-alias[22] \
   setp="command-prompt -p '[new path]: ' 'setw @window_current_path '%%''"

# ------------------------------------------------------------------
# split window (using previous pane's start-directory)
# ------------------------------------------------------------------
# [?] split window horizontally.
# set -s command-alias[23] \
    hsplit="split-window -vc '#{@window_current_path}'"

# [?] split window vertically.
# set -s command-alias[24] \
#     vsplit="split-window -hc '#{@window_current_path}'"

# [?] split window vertically.
# vsplit [pos] {[dir], [shortcut]} {[size], [percentage]} [target-pane] [shell-command] [format]
set -s command-alias[24] \
    vsplit="split-window -h"


set -g @packages '$XDG_CONFIG_HOME/nvim/pack/bundle/start'
# [?] neovim packages
# set -s command-alias[98] \
# packages='$XDG_CONFIG_HOME/nvim/pack/bundle/start'


# ------------------------------------------------------------------
#  Command-alias that accepts arguments.
# ------------------------------------------------------------------

# should be able to accept parameters.
# set -s command-alias[24] \
    vsplit="split-window -h"

# ------------------------------------------------------------------

# [?] copy paste (using xclip)
set -s command-alias[25] \
      yank="send-key -X copy-pipe-and-cancel 'xclip -in -selection clipboard'"

# ------------------------------------------------------------------
#  custom commands
# ------------------------------------------------------------------
set -s command-alias[33] \
add='splitw -fvl 12 "git add $(git status -s | fzf --preview '"'git diff'"')"'

set -s command-alias[83] \
todo='splitw -fvl 15 "todo | fzf"'

# [?] opening man pages
set -s command-alias[97] \
man='neww -n "#[italics] ManPage" \
"man $(apropos . | awk '"'{print $1}'"' | fzf  --border --margin=1,0,1 --height=100% )"'

# ------------------------------------------------------------------
#  Shortcuts
# ------------------------------------------------------------------

# [?] open apache2 server DocumentRoot
set -s command-alias[96] \
apache="neww -c /var/www/html"

# [?] quickly edit dotfiles.
set -s command-alias[93] \
dotfiles='splitw -fvl 12 "tmux neww -n testing '"'nvim --noplugin $(fzf)'"' "'

# [?] print all aliases without linebreaks.
set -s command-alias[82] \
alias='splitw -fvl 12 "tmux show-option -s command-alias | sed  '"'s/command-//g'"' | awk '"'{$1=$1};1'"' | fzf  "'

# [?] lists temporary aliases.
set -s command-alias[91] \
tempalias='splitw -fvl 12 "tmux show-option -scommand-alias"  '
