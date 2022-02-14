#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2154
# vim: ft=sh fdm=marker ts=2 sw=2 et

bind -m vi-command -x '"v": _visual_mode'

function _visual_mode() {
  local line="${READLINE_LINE}"
  local pt="${READLINE_POINT}"

  cursor_color="\e[106m\e[30m" # black fg, cyan bg
  line_color="\e[38;5;216m"
  sel_color="\e[48;5;237m${line_color}" # dimgrey bg
  prompt="\e[1m\e[38;5;35m╰➤\e[0m \e[38;5;242m$: \e[0m"
  resetbgfg="\e[39m\e[49m"
  local linewise=false

  local f=1
  local b=1

  function main() {
    __toggle_visual
    while :; do
      read -rn 1 key
      case "${1:-${key}}" in
        l )
          if [[ "${linewise}" == "true" ]]; then
            ((READLINE_POINT++))
            continue
          fi

          if [[ $b -gt 1 ]]; then
            (( b-- )) && _backward_char
          else
            ((f++)) && _forward_char
          fi
          continue
          ;;
        h )
          if [[ "${linewise}" == "true" ]]; then
            ((READLINE_POINT--))
            continue
          fi
          if [[ $f -gt 1 ]]; then
            (( f-- )) && _forward_char
          else
            (( b++ )) && _backward_char
          fi
          continue
        ;;
        y ) # yank
          ( command xclip -selection clipboard <<< "${visual}" & ) &> /dev/null
          READLINE_LINE="${line}"
          command tput cvvis
          return
          ;;
      V|v )
        linewise=true
        _linewise_visual
          ;;
        q ) # quit visual mode
          break
          ;;
      esac
    done
    command tput cnorm
  }



  function __toggle_visual() {
    command tput civis
    readline=(
      "${line_color}"
      "${line::pt}"
      "${cursor_color}${line:READLINE_POINT:1}${resetbgfg}"
      "${line_color}${line:(( pt + b ))}")

      __print_line
  }

  function _forward_char() {
      (( READLINE_POINT++ ))
      readline=(
        "${line_color}${line::pt}"
        "${sel_color}${line:pt:f-1}${resetbgfg}"
        "${cursor_color}${line:READLINE_POINT:1}${resetbgfg}" #cursor
        "${line_color}${line:(( pt + f ))}" )

    __print_line
  }

  function _backward_char() {
    (( READLINE_POINT-- ))
      readline=(
        "${line_color}${line::(( ( pt - b ) + 1 ))}"
        "${cursor_color}${line:READLINE_POINT:1}${resetbgfg}"
        "${sel_color}${line:((( pt + 2 ) - b )):(( b - 1 ))}${resetbgfg}"
        "${line_color}${line:(( pt + 1 ))}")
      __print_line
  }

  function _linewise_visual() {
    readline=(
      "${sel_color}${line::pt}"
      "${cursor_color}${line:pt:1}${resetbgfg}"
      "${sel_color}${line:pt+1}")
    __print_line
  }

  function __print_line() {
     printf "%b" "${prompt}" "${readline[@]}" "\r"
  }

  main
}
