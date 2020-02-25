#!/usr/bin/env bash

print_result() {
  if [[ "$1" -eq 0 ]]; then
    print_success "$2";
  else
    print_error "$2";
  fi
}

print_in_color() {
  printf "%b" \
    "$(tput setaf "$2" 2> /dev/null)" \
    "$1" \
    "$(tput sgr0 2> /dev/null)";
}

cmd_exists() { command -v "$1" &> /dev/null; }
ask()        { print_question "$1"; read -r; }
get_answer() { printf "%s" "$REPLY"; }

print_in_green()  { print_in_color "$1" 2; }
print_in_purple() { print_in_color "$1" 5; }
print_in_red()    { print_in_color "$1" 1; }
print_in_yellow() { print_in_color "$1" 3; }

print_warning()  { print_in_yellow "   [!] $1\n";    }
print_error()    { print_in_red    "   [✖] $1 $2\n"; }
print_success()  { print_in_green  "   [✔] $1\n";    }
print_question() { print_in_yellow "   [?] $1";      }

print_error_stream() {
  while read -r line; do
    print_error "↳ ERROR: $line";
  done
}

set_trap() {
  trap -p "$1" | grep "$2" &> /dev/null \
    || trap '$2' "$1";
}
answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] && {
    return 0;
  } || return 1;
}

confirm() {
  print_question "$1 [y/n]";
  read -r -n 1;
  printf "\n";
}

ask_for_sudo() {
  sudo -v &> /dev/null;
  while true; do
    sudo -n true;
    sleep 60;
    kill -0 "$$" || exit
  done &> /dev/null &
}

kill_all_subproc() {
  local i=""
  for i in $(jobs -p); do
    kill "$1";
    wait "$i" &> /dev/null;
  done
}

execute() {
  local -r cmd="$1";
  local -r message="${2:-$1}";
  local -r tmp_file="$(mktemp /tmp/XXXXX)";
  local exit_code=0;
  local cmd_pid=""
  # if the current process is ended,
  # also end all it's subprocesses.
  set_trap "EXIT" "kill_all_subproc";
  # Run commands in background.
  eval "$cmd" \
    &> /dev/null \
    2> "$tmp_file"
  cmd_pid=$!
  # show the spinner if the command
  # require more time to complete.
  show_spinner "$cmd_pid" "$cmd" "$message";
  # wait for the command to be no longer executing
  # in the background before getting their exit code.
  wait "$cmd_pid" &> /dev/null
  exit_code=$?
  # print output based on what happened.
  print_result $exit_code "$message";
  [[ $exit_code -ne 0 ]] && {
    print_error_stream < "$tmp_file";
  }
  rm -rf "$tmp_file";
  return $exit_code;
}


mkd() {
  if [ -n "$1" ]; then
    if [ -e "$1" ]; then
      if [ ! -d "$1" ]; then
        print_error "$1 - a file with the same name already exists!"
      else
        print_success "$1"
      fi
    else
      execute "mkdir -p $1" "$1"
    fi
  fi
}


show_spinner() {
  local -r frames='⣾⣽⣻⢿⡿⣟⣯⣷';
  local -r number_of_frames="${#frames}";
  local -r pid="$1"
  local -r cmd="$2";
  local -r message="$3";
  local i=0;
  local frame_text="";
  # NOTE: In order for the Travis CI site to display
  # things correctly, it needs special treatment, hence,
  # the "is Travis CI" checks.
  if [[ "$TRAVIS" != "true" ]]; then
    # Provide more space so that the text hopefully doesn't
    # reach the bottom of the terminal window.
    # think of this as the equivalent of
    # "scrolloff" option in vim/nvim.
    #
    # This is a workaround for escape sequences not tracking
    # the buffer position (accounting for scrolling).
    #
    # See also: https//unix.stackexchange.com/a/278888
    printf "\n\n\n"
    tput cuu 3
    tput sc
  fi
  # show spinner while the commands are being executed.
  while kill -0 "$pid" &> /dev/null; do
    frame_text="   [${frames:i++%number_of_frames:1}] $message"
    # display frame
    if [[ "$TRAVIS" != "true" ]]; then
      printf "%s\n" "$frame_text";
    else
      printf "%s" "$frame_text";
    fi
    sleep 0.1
    # clear frame
    if [[ "$TRAVIS" != "true" ]]; then
      tput rc
    else
      printf "\r"
    fi
  done
}
