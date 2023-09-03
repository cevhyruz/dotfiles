#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et


# Add this to the API.

function timer() {
  for i in "${runtime[@]}"; do
    TIMEFORMAT="${i//${HOME}/\~}: %R"
    time source "$i"
    unset TIMEFORMAT
  done; unset i
}
