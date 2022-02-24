#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2086,SC2145
# vim: ft=sh fdm=marker ts=2 sw=2 et

function main() {
  reset_bold="\e[22m"
  reset_underline="\e[24m"
  reset_reverse="\e[27m"
  defaultfg="\e[39m";
  defaultbg="\e[49m";
  reset="\e[0m"
  resetall="\e[0m${reset_bold}${reset_underline}${reset_reverse}";
  bold="\e[1m";
  dim="\e[2m";
  italic="\e[3m";
  underline="\e[4m";
  blink="\e[5m";
  reverse="\e[7m";
  hidden="\e[8m";
  strikethrough="\e[9m";
  normal="\e[38;5;247m";
  curvyline="${underline::-1}:${italic:3}";
  overline="\e[53m";
  double_underline="${underline::-1}:${dim:3}"
}

function __load_default_pallete () {
  bg_black="\e[40m"   fg_black="\e[30m"
  bg_red="\e[41m"     fg_red="\e[31m"
  bg_green="\e[42m"   fg_green="\e[32m"
  bg_yellow="\e[43m"  fg_yellow="\e[33m"
  bg_blue="\e[44m"    fg_blue="\e[34m"
  bg_magenta="\e[45m" fg_magenta="\e[35m"
  bg_cyan="\e[46m"    fg_cyan="\e[36m"
  bg_white="\e[47m"   fg_white="\e[37m"
}

function __make_dircolors_pallete () {
  local -ar dircolors=(
    "no=${normal:3:-1}:"              # NORMAL, NORM
    "fi=${normal:3:-1}:"              # FILE
    "di=${dim:3:-1};${normal:3:-1};${fg_cyan:3:-1}:" # DIR
    "ln=${italic:3:-1};${fg_blue:3:-1}:" # SYMLINK, LINK, LNK
    "or=${italic:3:-1};${fg_red:3:-1}:"  # ORPHAN
    "mi=${fg_red:3:-1}:"              # MISSING
    "bd=${fg_blue:3:-1}:"             # BLOCK, BLK
    "cd=${fg_red:3:-1}:"              # CHAR, CHR
    "ex=${fg_green:3:-1}:"            # EXEC
    "do=${normal:3:-1}:"              # DOOR
    "so=${normal:3:-1}:"              # SOCK
    "pi=${normal:3:-1}:"              # FIFO, PIPE
    "sg=${normal:3:-1}:"              # SETGID
    "su=${normal:3:-1}:"              # SETUID
    "st=${normal:3:-1}:"              # STICKY
    "tw=${normal:3:-1}:"              # STICKY_OTHER_WRITABLE
    "ow=${fg_magenta:3:-1}:" )        # OTHER_WRITABLE

  LS_COLORS=''
  for entry in ${dircolors[*]}; do
    LS_COLORS+="$entry"
  done
  export LS_COLORS
}

main && unset -f main
