#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Set up shell variables for Bash

# disable mailcheck.
unset MAILCHECK

# append current sessions history to the history file.
# PROMPT_COMMAND='history -a;'

# ::post_command "history -a"

_::command_exists "nvim" && VISUAL="nvim"

export EDITOR="$VISUAL"

# default browser
_::command_exists "google-chrome" && export BROWSER="/usr/bin/google-chrome"

# larger history (default: 500)
HISTSIZE=100000
HISTFILESIZE=$HISTSIZE

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL='ignorespace:erasedups';

# Force UTF-8 locale for all programs.
# Prevents broken unicode symbols.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
