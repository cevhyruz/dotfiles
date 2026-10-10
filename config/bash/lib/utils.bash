#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# bash config utility functions


__log_info() {
  [[ "$__LOGGER_PLUMBING_FLAG" -eq 1 ]] && return 0
  printf '%s[INFO]%s  %s\n' $'\033[0;34m' $'\033[0m' "$*"
}

__log_ok() {
  [[ "$__LOGGER_PLUMBING_FLAG" -eq 1 ]] && return 0
  printf '%s[ OK ]%s  %s\n' $'\033[0;32m' $'\033[0m' "$*"
}

__log_warn() {
  [[ "$__LOGGER_PLUMBING_FLAG" -eq 1 ]] && return 0
  printf '%s[WARN]%s  %s\n' $'\033[0;33m' $'\033[0m' "$*" >&2
}

__log_error() {
  printf '%s[FAIL]%s  %s\n' $'\033[0;31m' $'\033[0m' "$*" >&2
}

__log_die() {
  __log::error "$1"
  return 1
}

__utils_require_cmd() {
  local cmd="${1-}" hint="${2-}" message=""
  if ! command -v "$cmd" &>/dev/null 2>&1; then
    message="Missing required command: $cmd"
    [[ -n "$hint" ]] && message="$message ($hint)"
    __log::die "$msg"
  fi
  return 0
}
