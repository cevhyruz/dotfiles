#!/usr/bin/env bash
#
#
#
# [?] set key binding depending on user option value.
# usage: set_keys "-r C-y" "[cmd]"
function set_key() {
  local key table cmd

      cmd="$2"
      table="$( tmux show -gv "$1" | awk '{printf $1}')"
      key="$( tmux show -gv "$1" | awk '{printf $2}')"

    command tmux bind-key "$table $key $cmd"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# [?] set a window option.
# usage: setw [option], [value]
function window-option() {
  local var option value

  option="$1"
     var="${2}"
   value="$( display "${2}" )"

  command tmux set-window-option "$option" "${value}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# [?] set/change current session name.
# usage: sets_name [new-name]
function session-name() {
  local old_name new_name cwd

  cwd="$( display "#{pane_current_path}" )"
  old_name="$( display "#{session_name}" )"
  new_name="$( display "${1}" )"

  # if it's not a number its probably renamed
  # manually by user. hence, don't do anything.
  if ! [[ "$old_name" =~ ^[0-9]+$ ]]; then
    return 0
  elif [[ "$old_name" != "$cwd" ]]; then
    command tmux rename-session "$cwd"
  fi


  command tmux rename-session "$new_name"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# [?] set/change window name.
# usage: setw_name [target-window, new-name]
function setw_name() {
  local window new_name

    window="$( display "$1" )"
  new_name="$( display "$2" )"

  command tmux rename-window -t "$window" "$new_name"
}

# [?] print result to stdout.
# usage: display [env-var, option]
function display() {
  local var value

    var="$1"
  value="$( command tmux display-message -p "$var" )"

  printf "$value"
}

function _is_fullscreen() {
  command xprop -name "namehere" _NET_WM_STATE | grep -q _NET_WM_STATE_FULLSCREEN
}

