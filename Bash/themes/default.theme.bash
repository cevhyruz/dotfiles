#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Default bash prompt theme when BASH_PROMPT_THEME is not set or is empty.

# Set Bash PS1 prompt.
# Globals:
#   PS1

function _set_default_prompt() {
  local -ra PS1_PROMPT=(
    "\\[${green}\\]"
    "╭─"
    "\\[${white}\\]"
    " "
    "\\u"
    "@"
    "\\H"
    "\\[${green}\\]"
    "\\[${white}\\]"
    ":"
    "\\[${cyan}\\]"
    "\\W" # current working directory
    "\$( _core::_parse_SCM \" ${white}on \" \" \" )"
    " "
    "\$( _exit_code )"
    "\\n" # newline
    "\\[${green}\\]"
    "╰"
    "\\[${shade}\\]"
    " "
    "\\$"
    "\\[${pink}\\] "
  )

  printf "%b%s" "\\n" "${PS1_PROMPT[@]}"
}

_set_default_prompt && unset _set_default_prompt
