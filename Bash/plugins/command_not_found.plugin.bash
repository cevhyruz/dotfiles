#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# customized 'command not found' message for bash.

function command_not_found_handle() {
  printf "%s" "${PREFIX} - "
  printf "${SHELL}: %b\n" "\e[3;38;5;203m${*}\e[0m: Command not found"
  return 127
}
