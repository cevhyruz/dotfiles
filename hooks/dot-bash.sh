#!/usr/bin/env bash

exit_code=0

for file in "$@"; do

  # Confirm file is not executable
  #
  if [[ -x "${file}" ]]; then
    echo "Bash include file \`${file}\` should not be executable"
    exit_code=1
  fi

  LINE1="$(head -n 1 "${file}")"
  LINE2="$(head -n 2 "${file}" | tail -n 1)"
  LINE3="$(head -n 3 "${file}" | tail -n 1)"
  LINE4="$(head -n 4 "${file}" | tail -n 1)"
  LASTLINE="$(tail -n 1 "${file}")"

  regexp_shellcheck_header='^#[[:space:]]shellcheck[[:space:]]shell=bash'
  regexp_vim_modeline='^#[[:space:]](vi|vim|ex):[[:space:]]'

  # Confirm expected schellcheck header
  #
  if ! [[ "${LINE1}" =~ $regexp_shellcheck_header ]] \
    && ! [[ "${LINE2}" =~ $regexp_shellcheck_header ]] \
    && ! [[ "${LINE3}" =~ $regexp_shellcheck_header ]]; then
      echo "Bash include file \`${file}\` has bad/missing shellcheck header"
      exit_code=1
  fi

  # Confirm expected vim modeline
  #
  if ! [[ "${LINE2}" =~ $regexp_vim_modeline ]] \
    && ! [[ "${LINE3}" =~ $regexp_vim_modeline ]] \
    && ! [[ "${LINE4}" =~ $regexp_vim_modeline ]] \
    && ! [[ "${LASTLINE}" =~ $regexp_vim_modeline ]]; then
      echo "Bash file \`${file}\` don't have expected vim modeline"
      exit_code=1
  fi
done

exit $exit_code
