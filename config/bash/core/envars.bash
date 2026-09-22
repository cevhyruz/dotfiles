#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Set up shell variables for Bash


# Bash readline
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"

# Bash history
# Exported so 'bash --norc' wont create the history file at $HOME
export HISTFILE="${XDG_STATE_HOME}/bash/history"
export HISTSIZE=100000 
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL='ignorespace:erasedups';  # No dups and ignore commands that starts with a space

# --- Common tool overrides that respect XDG once told to ---
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Ensure directories for tool-specific overrides exist too, since some
# tools (bash history, less) won't create their parent dir automatically
# TODO: bootstrap this on setup
# mkdir -p "$(dirname "$HISTFILE")" "$(dirname "$LESSHISTFILE")" 2>/dev/null


__util::command_exists "nvim" && VISUAL="nvim"
export EDITOR="$VISUAL"
__util::command_exists "less" && export PAGER="less"
__util::command_exists "google-chrome" && export BROWSER="google-chrome"
