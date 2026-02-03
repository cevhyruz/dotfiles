#!/usr/bin/env bash
# shellcheck shell=bash
#
# coreutils for dotfiles


# Bootstrap _dotfiles_runtime files.
# @TODO: write a utility function for dotfiles to print where does a certain
# function/alias is coming from.

# TODO:
# Add a _dotfiles_runtime API so we are able to include a project from localrc.
# eg:
#   _dotfiles_runtime+=(/home/devs/Projects/visual-bash/vmb_init)
#   _dotfiles_runtime+=(/home/devs/Projects/bash-diagnostics/init.bash)

function init_config() {
  declare -a  scriptnames
  declare -ig scriptnames_index

  declare -ag _dotfiles_runtime=(
    "${DOT_BASH}"/{lib,core,plugins,completions,aliases,functions}/*
    "${DOT_BASH}/themes/${dotbash_theme}.bash"
    "${DOTFILES}/localrc/localrc.bash"
  )

  for config in "${_dotfiles_runtime[@]}"; do
    test -d "$config" && continue
    source "$config"
    scriptnames+=("${config}")
    (( scriptnames_index++ ))
  done
  unset config
}

function cleanup() {
  :;
}
