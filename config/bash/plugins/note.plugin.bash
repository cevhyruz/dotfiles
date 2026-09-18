#!/usr/bin/env bash
#
# simple note-taking tool.


# simple note-taking tool.
# shellcheck shell=bash disable=SC2164,SC2181
function note() {
  local note
  local location="${1:-${HOME}/Documents/notes}"

    pushd "${location}" &> /dev/null || return
    note="$(find "${location}" -maxdepth 1 -type f -exec basename {} ';' \
      | fzf --height=50% --sort --preview "cat ${location}/{}")"
    if [[ $? -ne 0 ]]; then
      popd &> /dev/null
      return 1
    fi
    "${EDITOR}" "${location}/${note}"
    popd &> /dev/null
}

