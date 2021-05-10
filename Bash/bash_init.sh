#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

set -u # treat unset variables as an error when substituting.
set +T # Disable trap DEBUG on subshells.

# load utility helper file.
source "${DOT_BASH}/lib/util.bash"

# initliaze configurations.
_::source_files_from "${DOT_BASH}/core"
_::source_files_from "${DOT_BASH}/aliases"

# local config file.
_::source_file "${DOTFILES}/localrc/local.bashrc"
