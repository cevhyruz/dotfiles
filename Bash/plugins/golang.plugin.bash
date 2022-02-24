#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
_::add_to_path "${GOBIN}"
