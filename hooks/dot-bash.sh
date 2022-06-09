#!/usr/bin/env bash

exit_code=0

function _print_error() {
  printf "%b" " \e[38;5;238m┃\e[0m $1 \n"
  exit_code=1
}

for file in "$@"; do
  LINE1="$(head -n 1 "${file}")"
  LINE2="$(head -n 2 "${file}" | tail -n 1)"
  LINE3="$(head -n 3 "${file}" | tail -n 1)"
  LINE4="$(head -n 4 "${file}" | tail -n 1)"
  LASTLINE="$(tail -n 1 "${file}")"
  regexp_shellcheck_header='^#[[:space:]]shellcheck[[:space:]]shell=bash'
  regexp_vim_modeline='^#[[:space:]](vi|vim|ex):[[:space:]]'

  printf "%b" "\n\e[38;5;203m${file}\e[0m\n"

  # Confirm file is not executable
  if [[ -x "${file}" ]]; then
    _print_error "- should not be an executable"
  fi

  # Confirm expected schellcheck header
  if ! [[ "${LINE1}" =~ $regexp_shellcheck_header ]] \
    && ! [[ "${LINE2}" =~ $regexp_shellcheck_header ]] \
    && ! [[ "${LINE3}" =~ $regexp_shellcheck_header ]]; then
      _print_error "missing Shellcheck header"
  fi

  # Confirm expected vim modeline
  if ! [[ "${LINE2}" =~ $regexp_vim_modeline ]] \
    && ! [[ "${LINE3}" =~ $regexp_vim_modeline ]] \
    && ! [[ "${LINE4}" =~ $regexp_vim_modeline ]] \
    && ! [[ "${LASTLINE}" =~ $regexp_vim_modeline ]]; then
      _print_error "missing Vim modeline"
  fi

done

exit $exit_code
