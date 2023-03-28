#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

# load utility helper file.
# shellcheck source=/dev/null

# shellcheck disable=SC2034

# Bootstrap runtime files.
# @TODO: write a utility function for dotfiles to print where does a certain
# function/alias is coming from.

declare -a runtime=(
  "${DOT_BASH}"/{lib,core,plugins,completions,aliases,functions}/*
  "$HOME/.fzf.bash"
  "${DOT_BASH}/themes/${dotbash_theme}.bash"
  "${DOTFILES}/localrc/localrc.bash"
)

# TODO:
# Add a runtime API so we are able to include a project from localrc.
# eg:
#   runtime+=(/home/devs/Projects/visual-bash/vmb_init)
#   runtime+=(/home/devs/Projects/bash-diagnostics/init.bash)

declare -a scriptnames=()
declare -i index=1
for config in "${runtime[@]}"; do
  source "$config"
  scriptnames+=("${index}: ${config}")
  (( index++ ))
done
unset config

# unset common functions
unset -f main
unset -f cleanup
