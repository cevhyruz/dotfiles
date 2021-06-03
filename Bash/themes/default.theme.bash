#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Default bash prompt theme when BASH_PROMPT_THEME is not set or is empty.

# Set Bash PS1 prompt.
# Globals:
#   PS1

# shellcheck disable=SC2034
function main() {
  # change color of the default foreground.
  PRE_COMMAND='_output_style 247;'

  _ls_colors

  _gs_staged="+"
  _gs_modified="!"
  _gs_untracked="?"
  _gs_stash="⁕"

  # init prompt components
  _host_style
  _cwd_style

  _set_prompt
}

function _output_style() {
  printf "%b" "\e[38;5;${1}m"
}

function _host_style() {
  if [[ -n "${SSH_TTY:-}" ]]; then
    host_style="\e[1;31m" # bold red
  else
    host_style="\e[1;38;5;172m" # bold white
  fi
}

function _cwd_style() {
  cwd_style="\e[1;36m"
}

function _return_arrow_style() {
  if [[ "${EXIT_CODE:-}" -eq 0 ]]; then
    printf "%b" "\e[1;38;5;35m" # bold green 256
  else
    printf "%b" "\e[1;38;5;203m" # bold red 256
  fi
}

function _set_prompt() {

  PS1="\n"
  PS1+="\[\e[0m\]" # reset
  PS1+="\[\e[1m\]" # bold
  PS1+="\[\$( _return_arrow_style )\]"
  PS1+="╭─ "
  PS1+="\[${host_style}\]\u@\H"
  PS1+="\[\e[0m\]"    # reset
  PS1+="\[\e[1;37m\]" # reset
  PS1+=":"
  PS1+="\[${cwd_style}\]\W"
  PS1+="\[\$( _core::_parse_SCM \"\e[1;37m on \e[38;5;203m\" \"\e[33m \" )\]"
  PS1+="\[\$( _exit_code \" \[\e[3;37m\]exited \" \"\[\e[38;5;203m\]\" )\]"
  PS1+="\n"
  PS1+="\[\$( _return_arrow_style )\]"
  PS1+="\[╰\]"
  PS1+="\[\e[0m\] $: " # begin reset
  PS1+="\[\e[38;5;216m\]"
}

function _ls_colors() {
  if [[ -x "/usr/bin/dircolors" ]]; then

    if [[ -r ~/.dircolors ]]; then
      eval "$(dircolors -b ~/dircolors)"
    fi

    alias dir="dir --color=always"
    alias egrep="egrep --color=always"
    alias fgrep="fgrep --color=always"
    alias grep="grep --color=always"
    alias lscolor="ls --color=always"
    alias vdir="vdir --color=always"
  fi

  LS_COLORS=""
  LS_COLORS+="no=0;39:"   # Global default
  LS_COLORS+="di=0;36:"   # Directory
  LS_COLORS+="ex=0;32:"   # Executable file
  LS_COLORS+="fi=0;39:"   # File
  LS_COLORS+="ec=:"       # Non-filename text
  LS_COLORS+="mi=0;31:"   # Non-existent file pointed to by a symlink
  LS_COLORS+="ln=target:" # Symbolic link
  LS_COLORS+="ow=0;35:"   # Other writable
  LS_COLORS+="or=31;01:"  # Symbolic link pointing to a non-existent file

  export LS_COLORS
}

function _cleanup() {
  unset -f _host_style
}

main && unset -f main
_cleanup && unset -f _cleanup
