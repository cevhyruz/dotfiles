#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Default bash prompt theme when BASH_THEME is not set.

function _set_powerline_prompt() {
  local -ra PS1_PROMPT=(
    "\\[${green}\\]"
    "╭─"
    "\\[${violet}\\]"
    " "
    "\\u"
    "@"
    "\\H"
    "\\[${green}\\]"
    "\\[${white}\\]"
    ":"
    "\\[${cyan}\\]"
    "\\w" # current working directory
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

  PS1="\\n$(printf %s "${PS1_PROMPT[@]}")"
}

_set_powerline_prompt && unset _set_powerline_prompt
