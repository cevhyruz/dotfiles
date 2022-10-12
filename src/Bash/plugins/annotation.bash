#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=sh fdm=marker ts=2 sw=2 et
#

# list files with TODO: and FIXME: notation
alias todo="grep --recursive 'TOD[O]: '"
alias fixme="grep --recursive 'FIXM[E]: '"


# @TODO: Features:
# list todo,fixme
# accepts option to include/exclude annotations from submodules
# accepts option to include/exclude files from .gitconfig
# accepts parameters like: todo [path]
# formatted output, something like:
#   1. Todo: Please add this description.


# extract information from a bash script file.
# @TODO:
#   extract metadata
#   extract functions
#   extract completions
#   extract variables
#   extract options (shopt|set)
