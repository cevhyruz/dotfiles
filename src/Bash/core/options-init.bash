#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Sane defaults based on loaded core options.

# Automatically omit `cd` to aliases that uses it,
# allows for expansion of an alias that references another alias.
if shopt -q autocd; then
  alias cd=' ';
else
  alias cd="cd ";
fi
