#!/usr/bin/env bash
#
#
#

 function _is_running() {
   local proc="${1}"
   eval "ps -o command --tty $(_get_tty) | grep --silent ${proc}"
 }

function _get_tty() {
  printf %s "$(tmux display-message -p '#{pane_tty}')"
}

# [?] print result to stdout.
# usage: display [env-var, option]
function _display() {
  local var value

    var="$1"
  value="$( command tmux display-message -p "$var" )"

  echo "$value"
}

# function set_command() {
  # tmux set-option -s command-alias[10] up='display "test"'
# }

function up() {
  local is_vim
  is_vim="$(_is_running vim)"

  tmux set-option -s command-alias[10] up='run -b "( "${is_vim}" )"'
}

up

# set_command
# ------------------------------------------------------------------
# command-aliases
# ------------------------------------------------------------------
