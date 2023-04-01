#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2086,SC2145
# vim: ft=sh fdm=marker ts=2 sw=2 et

function init::theme() {
  reset_bold="\e[22m"
  reset_underline="\e[24m"
  reset_reverse="\e[27m"
  reset="\e[0m"
  resetall="\e[0m"
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

  local -a colors=($@)
  local palette=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white")
  local prefix

  if [[ "${COLORTERM-}" =~ ^(truecolor|24bit)$ ]] || [[ "${TERM-}" =~ *256color* ]]; then
    local scheme_index=
    for style in Bg bg Fg fg; do
      case $style in
        Bg ) scheme_index=16 ;;
        bg ) scheme_index=0 ;;
        Fg ) scheme_index=24 ;;
        fg ) scheme_index=8 ;;
      esac
      (( scheme_index > 8 )) && prefix='38;5;' || prefix='48;5;'
      for (( i = 0; i < ${#palette[@]}; i++ )); do
        eval "declare -g ${style}${palette[i]}=\"\e[${prefix}${colors[scheme_index]}m\""
        (( scheme_index++ ))
      done
    done
  else
    for style in Bg bg Fg fg; do
      case $style in
        Bg ) prefix=10 ;;
        bg ) prefix=4 ;;
        Fg ) prefix=9 ;;
        fg ) prefix=3 ;;
      esac
      for (( i = 0; i < ${#palette[@]}; i++ )); do
        eval "declare -g ${style}${palette[i]}=\"\e[${prefix}${i}m\""
      done
    done
  fi
  unset style

  # test function for displaying scheme palette.
  function scheme() {
    local scheme_index=
    for style in Bg bf Fg fg; do
      case $style in
        Bg ) scheme_index=16 ;;
        bg ) scheme_index=0 ;;
        Fg ) scheme_index=24 ;;
        fg ) scheme_index=8 ;;
      esac
      for (( i = 0; i < 8; i++ )); do
        echo -en " \[48;5${colors[scheme_index]}m foobar ${reset}"
      done
    done
  }
}

function __make_dircolors_pallete () {
  # Strip '\e[' and 'm' from color variables.
  local -ar dircolors=(
    "no=${normal:3:-1}:"              # NORMAL, NORM
    "fi=${normal:3:-1}:"              # FILE
    "di=${dim:3:-1};${normal:3:-1};${fgcyan:3:-1}:" # DIR
    "ln=${italic:3:-1};${fgblue:3:-1}:" # SYMLINK, LINK, LNK
    "or=${italic:3:-1};${fgred:3:-1}:" # ORPHAN
    "mi=${fgred:3:-1}:"              # MISSING
    "bd=${fgblue:3:-1}:"             # BLOCK, BLK
    "cd=${fgred:3:-1}:"              # CHAR, CHR
    "ex=${fggreen:3:-1}:"            # EXEC
    "do=${normal:3:-1}:"              # DOOR
    "so=${fgmagenta:3:-1}:"              # SOCK
    "pi=${normal:3:-1}:"              # FIFO, PIPE
    "sg=${normal:3:-1}:"              # SETGID
    "su=${normal:3:-1}:"              # SETUID
    "st=${normal:3:-1}:"              # STICKY
    "tw=${normal:3:-1}:"              # STICKY_OTHER_WRITABLE
    "ow=${fgmagenta:3:-1}:" )        # OTHER_WRITABLE

  LS_COLORS=
  for entry in ${dircolors[*]}; do
    LS_COLORS+="$entry"
  done
  export LS_COLORS
  unset -v entry
}
