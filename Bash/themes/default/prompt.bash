#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2154,SC2034
# vim: ft=sh fdm=marker ts=2 sw=2 et

function __exit_code () {
  local -a exit_prompt=(
    "\e[0m"
    "$1"
    "$2"
    "${EXIT_CODE:-}"
    "\e[0m"
  );

  if [[ "${EXIT_CODE:-}" -ne 0 ]]; then
    printf "%b" "${exit_prompt[@]}";
  fi
}

function __return_arrow_style() {
  if [[ "${EXIT_CODE:-}" -eq 0 ]]; then
    printf "%b" "${bold}${fg_green}" # bold green 256
  else
    printf "%b" "${bold}${fg_red}" # bold red 256
  fi
}

function __git_prompt() {
  __in_git_repo || return

  if ! __in_git_dir; then
    git update-index --really-refresh -q &> /dev/null
    __has_staged && status+="+"
    __has_modified && status+="!"
    __has_untracked && status+="?"
    __has_stash && status+="*"
  fi

  local -a git_prompt=(
    "${reset}"
    "$1"
    "$(__git_branch)"
    "${reset}"
    "$2"
    "${status:-} "
    "${reset}"
  );

  printf "%b" "${git_prompt[@]}"
}

function __output_style() {
  printf "%b" "\e[38;5;${1}m"
}

function __set_ps1() {
  if [[ -n "${SSH_TTY:-}" ]]; then
   host_style="${bold}${fg_red}"
  else
    host_style="${bold}${fg_white}"
  fi

  local -a ps1=(
    "\[${reset}\]"
    "\n"
    "\[${reset}${bold}\]"
    "\$( __return_arrow_style )"
    "╭─"
    " "
    "\[${host_style}\]\u@\H"
    "\[${reset}${bold}\]"
    ":"
    "\[${fg_cyan}\]\W"
    "\$( __git_prompt \"\[${bold}${fg_white}\] on \[${fg_red}\]\" \"\[${bold}${fg_yellow}\] \")"
    "\$( __exit_code \"\[${italic}\]exited \" \"\[${fg_red}\]\")"
    "\n"
    "\[\$( __return_arrow_style )\]"
    "\[${return_arrow[2]}\]\[${return_arrow[3]}\]"
    "╰➤"
    "\[${reset}\]"
    " $: "
    "\[\e[38;5;216m\]" # LightSalmon1
  )

  PS1="$(printf "%s" "${ps1[@]}")"
}

function main() {
   __set_ps1

  # change color of the default foreground.
  PRE_COMMAND='__output_style 247;'
}

main
