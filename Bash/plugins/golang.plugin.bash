#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# https://go.dev/doc/install

export GO111MODULE=on
export GOPATH="${HOME}/go"
export GOBIN="/usr/local/go/bin"
_::add_to_path "/usr/local/go/bin"
_::add_to_path "${GOPATH}/bin"
