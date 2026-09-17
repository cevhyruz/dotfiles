#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# command-not-found handle — replaces the default apt/snap suggestion lookup
# with a fast, styled message only. We're not using the package-lookup
# feature, so skipping it entirely is strictly faster than invoking it.

# TODO: we can add the dispatcher recommendation here.
function command_not_found_handle() {
  if [[ -t 2 ]] && __util::supports_color; then
    printf "%b: Command not found\n" "\e[0;38;5;203m${1}\e[0m" >&2
  else
    printf "%s: Command not found\n" "${1}" >&2
  fi
  return 127
}
