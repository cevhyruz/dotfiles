#!/usr/bin/env bash
# shellcheck shell=bash
#
# vim: ft=sh fdm=marker ts=2 sw=2 et
# Set up shell variables for Bash


# Bash readline
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"

export HISTFILE="${XDG_STATE_HOME}/bash/history"

export HISTCONTROL='ignorespace:erasedups';  # No dups and ignore commands that starts with a space

export HISTTIMEFORMAT='(%a, %b-%d) %I:%M:%S%P  '

export HISTTIMEFORMAT=$'\e[2;36m(%a, %b-%d) %I:%M:%S%P\e[0m  '

export HISTIGNORE='ls*:cd*:pwd:exit:clear:history*:&:[ \t]*'

export HISTSIZE=100000 

export HISTFILESIZE=$HISTSIZE

# Common tool overrides that respect XDG once told t
export LESS='-i -M -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

if [[ -f "$XDG_CONFIG_HOME/wget/wgetrc" ]]; then
  export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
fi

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Ensure directories for tool-specific overrides exist too, since some
# tools (bash history, less) won't create their parent dir automatically
# TODO: bootstrap this on setup
# mkdir -p "$(dirname "$HISTFILE")" "$(dirname "$LESSHISTFILE")" 2>/dev/null

# __common::command_exists "nvim" && VISUAL="nvim"
# export EDITOR="$VISUAL"
# __common::command_exists "less" && export PAGER="less"
# __common::command_exists "google-chrome" && export BROWSER="google-chrome"
