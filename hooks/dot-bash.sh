#!/usr/bin/env bash

exit_code=0
for file in "$@"; do
  # Confirm file is not executable
  #
  if [[ -x "${file}" ]]; then
    echo "Bash include file \`${file}\` should not be executable"
    exit_code=1
  fi

  # Confirm expected schellcheck header
  #
  LINE1="$(head -n 1 "${file}")"
  LINE2="$(head -n 2 "${file}" | tail -n 1)"
  if [[ "${LINE1}" != "# shellcheck shell=bash" ]] &&
    [[ "${LINE2}" != "# shellcheck shell=bash" ]]; then
    echo "Bash include file \`${file}\` has bad/missing shellcheck header"
    exit_code=1
  fi

  # Confirm expected vim modeline
  #
  LINE3="$(head -n 3 "${file}" | tail -n 1)"
  if [[ "${LINE3}" != "# vi:ft=sh fdm=marker ts=2 sw=2 et" ]]; then
    echo "Bash file \`${file}\` don't have expected vim modeline"
    exit_code=1
  fi
done

exit $exit_code
