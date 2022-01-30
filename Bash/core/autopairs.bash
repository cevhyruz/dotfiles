#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# shamelessly ripoffed from https://github.com/nkakouros-original/bash-autopairs

__pairs=(
  "''"
  '""'
  '()'
  '[]'
  '{}'
)

function __smart_space() {
  AT_PROMPT=1
  local previous_char="${READLINE_LINE:READLINE_POINT-1:1}"
  local cursor_char="${READLINE_LINE:READLINE_POINT:1}"
  local readline="${READLINE_LINE::READLINE_POINT}"

  local spaced=false
  for pair in "${__pairs[@]:2}"; do
    if [[ "$previous_char" == "${pair:0:1}" ]] &&
      [[ "$cursor_char" == "${pair:1:1}" ]]; then
      readline+="  " && spaced=true
      break
    fi
  done

  if [[ "${spaced}" == false ]]; then
    readline+=" "
  fi

  readline+="${READLINE_LINE:READLINE_POINT}"
  READLINE_LINE="${readline}"
  (( READLINE_POINT++ ))
}


function __autopair() {

  # FIXME: Hack for hooks triggering on 'bind -x'
  AT_PROMPT=1

  local typed_char="$1"
  local opening_char="$2"
  local closing_char="$3"
  local previous_char="${READLINE_LINE:READLINE_POINT-1:1}"
  local cursor_char="${READLINE_LINE:READLINE_POINT:1}"

  local next_two_char="${READLINE_LINE:READLINE_POINT:2}"
  local prev_two_char="${READLINE_LINE:READLINE_POINT-2:2}"

  local readline="${READLINE_LINE::READLINE_POINT}"
  local literals=0

  quotes_char="${READLINE_LINE//[^${typed_char}]/}"

  # TODO: add support for literals

  # '' and ""
  if [[ "${opening_char}" == "${closing_char}" ]]; then

    # close pair
    if [[ "$(( ${#quotes_char} % 2 ))" -eq 1 ]]; then
      readline+="${typed_char}"
    # already paired, auto close
    elif [[ "${cursor_char}" == "${closing_char}" ]]; then
      :
    # pair
    elif [[ "$(( ${#quotes_char} % 2 ))" -eq 0 ]]; then
      readline+="${typed_char}${typed_char}"
    fi

  # () and {} and []
  # pair
  elif [[ "${typed_char}" == "${opening_char}" ]]; then
    readline+="${opening_char}${closing_char}"
  # already paired, auto close
  elif [[ "${cursor_char}" == "${closing_char}" ]]; then
    :
  # close pair
  else
    readline+="${typed_char}"
  fi

  readline+="${READLINE_LINE:READLINE_POINT}"
  READLINE_LINE="${readline}"
  ((READLINE_POINT++))
}

function __depair() {

  # FIXME: Hack for hooks triggering on 'bind -x'
  AT_PROMPT=1

  if [[ "${#READLINE_LINE}" -eq 0 || "$READLINE_POINT" -eq 0 ]]; then
    return
  fi

  local next_two_char="${READLINE_LINE:READLINE_POINT:2}"
  local prev_two_char="${READLINE_LINE:READLINE_POINT-2:2}"

  local previous_char="${READLINE_LINE:READLINE_POINT-1:1}"
  local cursor_char="${READLINE_LINE:READLINE_POINT:1}"

  local readline
  readline="${READLINE_LINE::READLINE_POINT-1}"

  local autopair_operated=false
  local spaced_pair=false


  # ()[]{}
  for pair in "${__pairs[@]:2}"; do
    if [[ "${prev_two_char}" == "${pair:0:1} " ]] &&
      [[ "${next_two_char}" == " ${pair:1:1}" ]]; then
      readline="${READLINE_LINE:0:READLINE_POINT-1}${READLINE_LINE:READLINE_POINT+1}"
      spaced_pair=true
      break
    fi

    if [[ "$previous_char" == "${pair:0:1}" ]] &&
      [[ "$cursor_char" == "${pair:1:1}" ]]; then
      readline+="${READLINE_LINE:READLINE_POINT+1}"
      autopair_operated=true
      break
    fi
  done

  # ""''
  for pair in "${__pairs[@]:0:2}"; do
    if [[ "$previous_char" == "${pair:0:1}" ]] &&
      [[ "$cursor_char" == "${pair:1:1}" ]]; then

      num_of_char="${READLINE_LINE//[^${pair:0:1}]/}"

      if [[ "$(( ${#num_of_char} % 2))" -eq 1 ]]; then
        break
      fi

      readline+="${READLINE_LINE:READLINE_POINT+1}"
      autopair_operated=true
      break
    fi
  done

  if [[ "${autopair_operated}" == 'false' ]] \
    && [[ "${spaced_pair}" == 'false' ]]; then
    readline+="${READLINE_LINE:READLINE_POINT}"
  fi

  READLINE_LINE="${readline}"
  ((READLINE_POINT--))
}

function _pair() {
  # Show where the matching open paren is when inserting a closing one. Disabling
  # as it hijacks the `)`, `]` and `}` characters to enable blinking.
  bind "set blink-matching-paren off"

  BASH_AUTOPAIR_BACKSPACE=1

  for pair in "${__pairs[@]}"; do
    bind -m vi-insert -x \
      "\"\\${pair:0:1}\": __autopair \\${pair:0:1} \\${pair:0:1} \\${pair:1:1}"

    if [[ "${pair:0:1}" != "${pair:1:1}" ]]; then
      bind -m vi-insert -x \
        "\"${pair:1:1}\": __autopair \\${pair:1:1} \\${pair:0:1} \\${pair:1:1}"
    fi
  done
  unset pair

  bind -m vi-insert -x '"\C-h": __depair'

  if [[ -v BASH_AUTOPAIR_BACKSPACE ]]; then
    # https://lists.gnu.org/archive/html/bug-bash/2019-11/msg00129.html
    bind 'set bind-tty-special-chars off'
    bind -m vi-insert -x '"\C-?": __depair'
  fi

  # space
  bind -m vi-insert -x '" ": __smart_space'

}

if [[ -z "${BATS_TEST_NAME:-}" ]]; then
  _pair
fi