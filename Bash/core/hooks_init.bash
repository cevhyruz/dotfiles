#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034
# vim: ft=sh fdm=marker ts=2 sw=2 et

# initialize preloaded hooks.bash from library.

# avoid __pre_command firing before the prompt.
FIRST_PROMPT=1

# initialize __pre_command on DEBUG
trap '__pre_command' DEBUG

# initalize __post_command after every prompt.
PROMPT_COMMAND+=('__post_command')
