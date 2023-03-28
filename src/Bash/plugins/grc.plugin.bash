#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2294,SC2206,SC2034
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# generic colouriser

_::command_exists "grc" || return

if [[ "$TERM" != dumb ]]; then
    alias colourify="command grc --stderr --stdout --colour=auto"
    alias configure='grc ./configure'
    for app in {diff,make,gcc,g++,ping,traceroute}; do
      alias "$app"='colourify '$app
  done
fi
