#!/usr/bin/env bash
# shellcheck shell=bash source=/dev/null disable=SC2162
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Manage your app ruby's environment.

export RBENV_ROOT="${HOME}/Projects/cloned-repo/rbenv"

_::add_to_path "${RBENV_ROOT}/shims" "after"
_::add_to_path "${RBENV_ROOT}/bin" "after"

function rbenv() {
  local command="${1:-}"

  if [[ "$#" -eq 0 ]]; then
    echo "Note: to upgrade 'ruby-build' plugin"
    echo "run 'rbenv-rb-update' function.\n"
  else
    shift
  fi

  case "$command" in
    rehash|shell) eval "$(rbenv "sh-$command" "$@")";;
    *) command rbenv "$command" "$@";;
  esac
}

function rbenv-rb-update() {
  command git -C "${RBENV_ROOT}"/plugins/ruby-build pull
}
