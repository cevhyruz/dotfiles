#!/usr/bin/env bash


# set tmux custom behaviour

# shellcheck disable=SC1090
source "$HOME/Projects/dotfiles/tmux/lib.sh"

function main() {

  # executables
  if ! printenv PATH | grep "tmux/bin" &> /dev/null; then
    command tmux setenv -g "PATH" "$PATH:$HOME/Projects/dotfiles/tmux/bin"
  fi

  #
  window-option "@window_current_path" "#{pane_current_path}"
  session-name "#{b:pane_current_path}"
}

function setenv() {
  local fzf
  # fzf="$(echo "$FZF_DEFAULT_OPTS")"

  # command tmux display -p "$FZF_DEFAULT_OPTS"
  # echo $FZF_DEFAULT_OPTS
}

function git-stream-status() {
  local working_dir

  working_dir="$( display '#{@window_current_path}' )"

  tmux set status-right "$working_dir"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main



# and/or
function set-session-alias() {
  local name index cmd
  eval "tmux set -s command-alias[${index}] ${name} ${cmd}"
}


# tmux set -s command-alias[92] testigo="display" "$(testigo)"
# eval "tmux set -s command-alias[55] testigo=display -p "$(_get_tty)""
