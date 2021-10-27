#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

# load utility helper file.
# shellcheck source=/dev/null
for file in "${DOT_BASH}/lib"/*; do
  source "${file}"
  unset file
done

# initliaze configurations.
_::source_files_from "${DOT_BASH}/core"
_::source_files_from "${DOT_BASH}/aliases"
_::source_files_from "${DOT_BASH}/plugins"

# local config file.
_::source_file "${DOTFILES}/localrc/local.bashrc"
