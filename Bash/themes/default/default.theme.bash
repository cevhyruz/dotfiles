#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2154
# vi: ft=sh fdm=marker ts=2 sw=2 et
#
# Default bash prompt theme when BASH_PROMPT_THEME is not set or is empty.

function main() {
  __load_ansi_attrib
  __make_theme
  __make_dircolors_pallete

  source "${DOT_BASH}/themes/default/prompt.bash"
}

function __make_theme() {
  if [[ "${COLORTERM}" =~ ^(truecolor|24bit)$ ]]; then
    bg_black="\e[48;5;234m"  fg_black="\e[38;5;234m"
    bg_red="\e[48;5;203m"    fg_red="\e[38;5;203m"
    bg_green="\e[48;5;35m"   fg_green="\e[38;5;35m"
    bg_yellow="\e[48;5;221m" fg_yellow="\e[38;5;221m"
    bg_blue="\e[34m"         fg_blue="\e[34m"
    bg_magenta="\e[35m"      fg_magenta="\e[35m"
    bg_cyan="\e[36m"         fg_cyan="\e[36m"
    bg_white="\e[37m"        fg_white="\e[37m"
  else
    __load_default_pallete
  fi
}

function __load_dircolors() {
  local -ar __dircolors=(
    "no=${__normal}:"              # NORMAL, NORM
    "fi=${__normal}:"              # FILE
    "di=${__normal};${__fg_cyan}:" # DIR
    "ln=${__italic};${__fg_blue}:" # SYMLINK, LINK, LNK
    "or=${__italic};${__fg_red}:"  # ORPHAN
    "mi=${__fg_red}:"              # MISSING
    "bd=${__fg_blue}:"             # BLOCK, BLK
    "cd=${__fg_red}:"              # CHAR, CHR
    "ex=${__reset};${__fg_green}:" # EXEC
    "do=${__normal}:"              # DOOR
    "so=${__normal}:"              # SOCK
    "pi=${__normal}:"              # FIFO, PIPE
    "sg=${__normal}:"              # SETGID
    "su=${__normal}:"              # SETUID
    "st=${__normal}:"              # STICKY
    "tw=${__normal}:"              # STICKY_OTHER_WRITABLE
    "ow=${__fg_magenta}:"          # OTHER_WRITABLE

    # version control
    "*.git=${__fg_yellow}:"
    "*.gitignore=${__dim};${__fg_yellow}:"
    "*.gitattributes=${__dim};${__fg_yellow}:"
    "*.gitmodules=${__dim};${__fg_yellow}:"

    # configuration file
    "*.yaml=${__dim};${__fg_white}:"
    "*.yml=${__dim};${__fg_white}:"
    "*.shellcheckrc=${__dim};${__fg_white}:"
    "*.simplecov=${__dim};${__fg_white}:"
    "*.editorconfig=${__dim};${__fg_white}:"

    # documents
    "*README.md=${__fg_yellow}:"
    "*README=${__fg_yellow}:"
    "*LICENSE=${__fg_yellow}:"

    # shell script file
    "*.awk=${__fg_yellow}:"
    "*.bash=${__fg_yellow}:"
    "*.bat=${__fg_yellow}:"
    "*.sh=${__fg_yellow}:"
    "*.zsh=${__fg_yellow}:"
    "*.vim=${__fg_yellow}:"
  )

  __make_dircolors
}

main
