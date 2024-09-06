#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

# load utility helper file.
# shellcheck source=/dev/null

# shellcheck disable=SC2034


source "${DOTFILES}/src/Bash/core/utils.bash"

# check if the required program for plugins are installed,
# if yes, we'll declare a variable for reference.
declare varname
for prereq in "${!plugins[@]}"; do
  [[ -z "${plugins[$prereq]}" ]] && continue
  varname="__plug_${plugins[$prereq]}_installed"
  if command -v "${plugins[$prereq]}" &>/dev/null; then
    if ! declare -p "$varname" &>/dev/null; then
      eval "declare -g __plug_${plugins[$prereq]}_installed=1"
    fi
  fi
done


init_config

unset varname


# unset common functions
unset -f main
unset -f cleanup
