#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# https://go.dev/doc/install

export GO111MODULE=on
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
_::add_to_path "${GOBIN}"

function go() {
  # return golang executables
  if [[ "${1:-}" == 'list' ]]; then
    ls "$GOBIN"
    return
  fi

  "${GOBIN}/go" "$@"
}
