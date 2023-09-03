#!/usr/bin/env bash
#
# Helper functions for setting up dotfiles.

function _print() {
  printf "%b" \
    "$(tput setaf "$2" 2> /dev/null)" \
    "$1" \
    "$(tput sgr0 2> /dev/null)"
}


function _print::green()  { _print "$1" 2; }
function _print::purple() { _print "$1" 5; }
function _print::red()    { _print "$1" 1; }
function _print::yellow() { _print "$1" 3; }

function print::question() { _print::yellow "${INDENTION-}[?] $1";        }
function print::success()  { _print::green  "${INDENTION-}[Done] $1\n";   }
function print::warn()     { _print::yellow "${INDENTION-}[Warn] $1\n";   }

function print::error()    { _print::red    "${INDENTION-}[Err] $1 $2\n"; }

function print::error_stream() {
  while read -r line; do
    print::error "↳ ERROR: $line"
  done
}

function print::result() {
  if [[ "$1" -eq 0 ]]; then
    print::success "$2";
  else
    print::error "$2";
  fi
  return "$1";
}

function ask() {
  print::question "$1";
  read -r;
}

function ask::confirm() {
  print::question "$1 (y/n) ";
  read -r -n 1;
  printf "\n";
  case "${REPLY}" in
    y) return 0;
      ;;
    n) return 1;
      ;;
    *) ask::confirm "${1}";
  esac
}

function ask::install_location() {
  dotfiles_dir="";
  while [[ -z "${dotfiles_dir}" ]]; do
    ask "Please choose another location for installation (path)";
    dotfiles_dir=${REPLY};
  done
}

function ask::sudo() {
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

function execute::_kill_subproc() {
  local i=""
  for i in $(jobs -p); do
    kill "$i";
    wait "$i";
  done &> /dev/null
}

function set_trap() {
  # shellcheck disable=2064
  trap -p "$1" | grep "$2" &> /dev/null \
    || trap "$2" "$1"
}

function cleanup() {
  execute::_kill_subproc;
  \rm -v "${TMP_FILES[@]}";
}


# execute commands with a spinner.
# @param1: [cmd]
# @param2: [message]
#
function execute() {
  local -r FRAMES='/-\|'
  local -r NUMBER_OR_FRAMES=${#FRAMES}
  local -r CMDS="$1"
  local -r MSG="${2:-$1}"
  local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

  TMP_FILES+=("${TMP_FILE}")

  local exitCode=0
  local cmdsPID=""

  local i=0
  local frameText=""

  set_trap "EXIT" "cleanup"

  eval "$CMDS" \
    &> /dev/null \
    2> "$TMP_FILE" &
  cmdsPID=$!;

  while kill -0 "$cmdsPID" &>/dev/null; do
    frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
    printf "%s" "$frameText";
    sleep 0.1;
    printf "\r";
  done

  wait "$cmdsPID" &> /dev/null;
  exitCode=$?;

  print::result $exitCode "$MSG";

  if [[ $exitCode -ne 0 ]]; then
    print::error_stream < "$TMP_FILE";
  fi

  return $exitCode;
}
