#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2154,SC2016
# vi: ft=sh fdm=marker ts=2 sw=2 et
#
# Default bash theme when BASH_PROMPT_THEME is not set or is empty.

function main() {

  declare -a colorscheme=(
    "101" "147" "219" "247" "56"  "225" "154" "126"
    "209" "85"  "97"  "95"  "215" "208" "256" "148"
    "71"  "18"  "130" "216" "28"  "226" "246" "246"
    "216" "99"  "254" "169" "38"  "237" "196" "112"
  )

  init::theme "${colorscheme[@]}"

  __make_dircolors_pallete

  _set_prompts
}

function  set_default_palette::ansi() {
  if has_truecolors; then
    for style in Bg bg Fg fg; do
      local scheme_index=
      case $style in
        Bg) scheme_index=16 ;;
        bg) scheme_index=0 ;;
        Fg) scheme_index=24 ;;
        fg) scheme_index=8 ;;
      esac
      if (( scheme_index > 8 )); then
        prefix="38;5;"
      else
        prefix="48;5;"
      fi
      for (( i = 0; i < ${#palette[@]}; i++ )); do
        eval "${style}${palette[i]}=\"\e[${prefix}${colors[scheme_index]}m\""
        (( scheme_index++ ))
      done
    done
    unset style
  else
    test
  fi
}


function _set_prompts() {
  _make_prompt_var "arrow_color" \
    "\[${bold}\]\[${Bggreen}\]" \
    "\[${bold}\]\[${Bgred}\]"

  _make_prompt_var "return_string" \
    "" "\[${resetall}\]\[${dim}\]\t\t[exited ${EXIT_CODE-}]\[${reset}\]"

  local -a arrow=(
    "${arrow_color}╭─\[${reset}\]"
    "${arrow_color}├─\[${reset}\]"
    "${arrow_color}╰─➤\[${reset}\]" )

  test -n "${SSH_TTY:-}" &&
    userhost_color="\[${Bgred}\]" ||
    userhost_color="\[${Bgwhite}\]"

   [[ "${USER}" == 'root' ]] &&
    userhost_color="\[${Bgred}\]" ||
    userhost_color="\[${Bgwhite}\]"

  if [[ -n "${VIRTUAL_ENV:-}" ]]; then
    local -a virtual_env=(
      "${arrow[1]}"
      "\[${normal}\]"
      "\[${dim}\]"
      "${VIRTUAL_ENV//${PYENV_ROOT}/PYENV_ROOT}"
      "\n"
    )
  fi

  local -a prompt=(
    "\[${reset}\]\[${normal}\]"
    "${arrow[0]}"
    "${userhost_color} \\\u@\H"
    "\[${Bgmagenta}\]:"
    "\[${Bgcyan}\]\w"
    "$( _prompt_git_head   "${Bggreen}" "${Bgred}" "${Bgyellow}" "${Bgwhite}:" )"
    "$( _prompt_git_status "${Bgyellow}" )"
    "${return_string}"
    "\n"
    "${virtual_env[@]}"
    "${arrow[2]}"
    "\[${reset}${dim}\]"
    " \$: "
    "\[${reset}\]"
    "\[\e[38;5;216m\]" )

  # PROMPT_DIRTRIM=2
  PS1="$(printf "%b" "${prompt[@]}")"

  # PS1 does not reset the final escape sequence of the prompt string,
  # we need to normalize after reading and before executing the command.
  PS0='$(printf "${normal}")'

  # Re-assign PS1 so we can get return status.
  ::post_command "${FUNCNAME[0]}"

  # Print newline after every command.
  ::post_command "printf '\n'"

  unset -v arrow_color
  unset -v return_string

  PS2="${reset}${normal}${arrow[2]}${reset}${dim} \$: ${reset}\[\e[38;5;216m\]"

  PS4='$(_ps4_callstack)'
}

main
