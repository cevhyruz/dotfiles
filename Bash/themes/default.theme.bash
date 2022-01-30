#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2154,SC2016
# vi: ft=sh fdm=marker ts=2 sw=2 et
#
# Default bash prompt theme when BASH_PROMPT_THEME is not set or is empty.

function main() {
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

  __make_dircolors_pallete

  # set ps1
  PS1="\[${reset}${bold}${normal}\]"
  local -a ps1=(
    "\n"
    "\[$(__exit_color)\]"
    "╭─"
    " "
    "\[$(__prompt_user_at_host)\]"
    "\u@\H"
    ":"
    "\[${fg_cyan}\]\w"
    " "
    "\[$(__git_prompt)\]"
    "\[$(__prompt_return_exit_code)\]"
    "\[${reset}\]"
    "\n"
    "\[$(__exit_color)\]"
    "╰➤"
    "\[${reset}\]"
    "\[${dim}\] \$: \[${reset}\]"
    "\[\e[38;5;216m\]") # LightSalmon1
  PS1+="$(printf "%b" "${ps1[@]}")"

  # change command output color.
  PRE_COMMAND+=('printf "%b" "${normal}";')


  # distinguishable cursor shapes for vi mode.
  # only works on GNU readline v7.0 (bash 4.3 and up).
  if [[ -z "${BATS_TEST_NAME:-}" ]]; then
    bind 'set show-mode-in-prompt on'
    bind 'set vi-ins-mode-string \1\e[5 q\e]12;cyan\a\2'
    bind 'set vi-cmd-mode-string \1\e[2 q\e]12;cyan\a\2'
  fi

}

main && unset -f main
