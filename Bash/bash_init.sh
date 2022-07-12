#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

# load utility helper file.
# shellcheck source=/dev/null
for file in "${DOT_BASH}/lib"/*; do
  source "${file}"
done

# initliaze configurations.
for file in "${DOT_BASH}/core"/*; do
  source "${file}"
done

# ordered
for file in "${DOT_BASH}/plugins"/*; do
  source "${file}"
done

#_::source_files_from "${DOT_BASH}/aliases"
for file in "${DOT_BASH}/aliases"/*; do
  source "${file}"
done

for file in ${file} "${DOT_BASH}/functions"/*; do
  source "$file"
done

source "${DOT_BASH}/themes/default.theme.bash"

# local config file.
# source "${DOT_BASH}/.bashrc.local"
unset file
