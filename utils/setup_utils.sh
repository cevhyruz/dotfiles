#!/usr/bin/env bash
#
# Helper functions for setting up dotfiles.

function ask_for_confirmation() {
  print_question "$1 (y/n) ";
  read -r -n 1;
  printf "\n";
}

function ask_for_sudo() {
  sudo -v &> /dev/null
  # Keep-alive: update existing sudo time stamp until script is done.
  # https://gist.github.com/cowboy/3118588
  while true; do
    sudo -n true;
    sleep 60;
    kill -0 "$$" || exit;
  done &> /dev/null &
}

function cmd_exists() { command -v "$1" &> /dev/null; }

function answer_is_yes() { [[ "$REPLY" =~ ^[Yy]$ ]] && return 0 || return 1; }

function ask() { print_question "$1" read -r; }

function kill_all_subprocesses() {
  local i=""
  for i in $(jobs -p); do
    kill "$i";
    wait "$i" &> /dev/null;
  done
}

function execute() {
  local -r CMDS="$1"
  local -r MSG="${2:-$1}"
  local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

  local exitCode=0
  local cmdsPID=""

  set_trap "EXIT" "kill_all_subprocesses"

  # execute commands in background.
  eval "$CMDS" \ &> /dev/null \ 2> "$TMP_FILE" &
  cmdsPID=$!

  # show a spinner if the commands require more time to complete.
  show_spinner "$cmdsPID" "$CMDS" "$MSG"

  # wait for the commands to finish on background to get exit codes.
  wait "$cmdsPID" &> /dev/null
  exitCode=$?

  # print output based on what happened.
  print_result $exitCode "$MSG"
  if [[ $exitCode -ne 0 ]]; then
      print_error_stream < "$TMP_FILE"
  fi

  rm -rf "$TMP_FILE"
  return $exitCode
}

function get_answer() { printf "%s" "${REPLY}"; }

function is_git_repository() { git rev-parse &> /dev/null; }

function mkd() {
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

function print_error_stream() {
  while read -r line; do
    print_error "↳ ERROR: $line"
  done
}

function print_in_color() {
  printf "%b" \
    "$(tput setaf "$2" 2> /dev/null)" \
    "$1" \
    "$(tput sgr0 2> /dev/null)"
}

function print_in_green()  { print_in_color "$1" 2; }
function print_in_purple() { print_in_color "$1" 5; }
function print_in_red()    { print_in_color "$1" 1; }
function print_in_yellow() { print_in_color "$1" 3; }

function print_question() { print_in_yellow "   [?] $1";      }
function print_error()    { print_in_red    "   [x] $1 $2\n"; }
function print_success()  { print_in_green  "   [/] $1\n";    }
function print_warning()  { print_in_yellow "   [!] $1\n";    }

function print_result() {
  if [[ "$1" -eq 0 ]]; then
    print_success "$2";
  else
    print_error "$2";
  fi
  return "$1";
}

function skip_questions() {
  while :; do
    case $1 in
      -y|--yes) return 0 ;;
       *) break ;;
    esac
    shift 1;
  done
  return 1;
}

function show_spinner() {
  local -r FRAMES='/-\|'

  local -r NUMBER_OR_FRAMES=${#FRAMES}

  local -r CMDS="$2"
  local -r MSG="$3"
  local -r PID="$1"

  local i=0
  local frameText=""

  # Provide more space so that the text hopefully
  # doesn't reach the bottom line of the terminal window.
  # This is a workaround for escape sequences not tracking
  # the buffer position (accounting for scrolling).
  # See also: https://unix.stackexchange.com/a/278888
  printf "\n\n\n";
  tput cuu 3;
  tput sc;

  # show spinner while the commands are running.
  while kill -0 "$PID" &>/dev/null; do
    frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
    # print frames
    if [ "$TRAVIS" != "true" ]; then
        printf "%s\n" "$frameText";
    else
        printf "%s" "$frameText";
    fi
    sleep 0.2
    # clear frames
    if [ "$TRAVIS" != "true" ]; then
        tput rc;
    else
        printf "\r";
    fi
  done
}
