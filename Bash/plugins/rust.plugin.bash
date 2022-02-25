#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

export RUSTUP_HOME="${HOME}/.rustup"
export CARGO_HOME="${HOME}/.cargo"

_::add_to_path "${CARGO_HOME}/bin"
