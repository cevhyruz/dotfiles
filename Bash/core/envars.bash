#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Set up shell variables for Bash

# disable mailcheck.
if [[ $( shopt mailwarn | awk '{ print $2 }' ) == 'off' ]]; then
  unset MAILCHECK
fi

# append current sessions history to the history file.
PROMPT_COMMAND=('history -a;')

# useful editors.
VISUAL="$(command -v nvim || command -v vim || command -v )"
EDITOR="${VISUAL}"
export EDITOR

# larger history (default: 500)
HISTSIZE=20000
HISTFILESIZE=20000

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL='ignorespace:erasedups';
HISTIGNORE='bash:fish:zsh:dash:exit:logout:clear:pushd:popd:ls:echo';
