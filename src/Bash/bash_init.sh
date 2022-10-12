#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

# load utility helper file.
# shellcheck source=/dev/null

# shellcheck disable=SC2034

# If not running interactively, don't do anything

# Bootstrap runtime files.
# @TODO: write a utility function for dotfiles to print where does a certain
# function/alias is coming from.

declare -a runtime=(
  "${DOT_BASH}"/{lib,core,plugins,aliases,functions,completions,themes/${dotbash_theme}}/*
  "${DOTFILES}/localrc/localrc.bash"
)

if [[ -f ~/Projects/forked-repo/bash-completion/bash_completion ]]; then
  runtime+=(/usr/share/bash-completion/bash_completion)
fi

for config in "${runtime[@]}"; do
  source "${config}"
done
unset config
