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
  local -ar __lscolors=(
    '__reset'         '__bg_black'   '__fg_black'
    '__bold'          '__bg_red'     '__fg_red'
    '__italic'        '__bg_green'   '__fg_green'
    '__reverse'       '__bg_yellow'  '__fg_yellow'
    '__defaultfg'     '__bg_blue'    '__fg_blue'
    '__defaultbg'     '__bg_magenta' '__fg_magenta'
    '__underline'     '__bg_cyan'    '__fg_cyan'
    '__strikethrough' '__bg_white'   '__fg_white'
    '__dim'
    '__normal' )

  for color in ${__lscolors[*]}; do
    eval "local ${color}=$(echo -E \"\$\{${color:2}:3:-1\}\")"
  done

  local -ar dircolors=(
    "no=${__normal}:"              # NORMAL, NORM
    "fi=${__normal}:"              # FILE
    "di=${__dim};${__normal};${__fg_cyan}:" # DIR
    "ln=${__italic};${__fg_blue}:" # SYMLINK, LINK, LNK
    "or=${__italic};${__fg_red}:"  # ORPHAN
    "mi=${__fg_red}:"              # MISSING
    "bd=${__fg_blue}:"             # BLOCK, BLK
    "cd=${__fg_red}:"              # CHAR, CHR
    "ex=${__fg_green}:"            # EXEC
    "do=${__normal}:"              # DOOR
    "so=${__normal}:"              # SOCK
    "pi=${__normal}:"              # FIFO, PIPE
    "sg=${__normal}:"              # SETGID
    "su=${__normal}:"              # SETUID
    "st=${__normal}:"              # STICKY
    "tw=${__normal}:"              # STICKY_OTHER_WRITABLE
    "ow=${__fg_magenta}:" )        # OTHER_WRITABLE

  LS_COLORS=''
  for entry in ${dircolors[*]}; do
    LS_COLORS+="$entry"
  done
  export LS_COLORS
}

main && unset -f main
