#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

# load utility helper file.
# shellcheck source=/dev/null
# shellcheck disable=SC2034
source "${DOTFILES}/src/Bash/core/utils.bash"

# check if the required program for plugins (See .bashrc.template) are installed,
# if yes, we'll declare a variable for reference.
declare varname
for prereq in "${!plugins[@]}"; do
  [[ -z "${plugins[$prereq]}" ]] && continue
  varname="__plug_${plugins[$prereq]}_installed"
  if command -v "${plugins[$prereq]}" &>/dev/null; then
    if ! declare -p "$varname" &>/dev/null; then
      # TODO: add this to logger.
      eval "declare -g __plug_${plugins[$prereq]}_installed=1"
    fi
  fi
done

# ╭─ cevhyruz@codelab:~/Projects/dotfiles:develop  +!*
# ╰─➤ $: hyperfine 'bash -ic "exit"'
# Benchmark 1: bash -ic "exit"
#   Time (mean ± σ):     103.1 ms ±   6.1 ms    [User: 79.0 ms, System: 25.1 ms]
#   Range (min … max):    92.0 ms … 114.4 ms    27 runs

# ╭─ cevhyruz@codelab:/etc:
# ╰─➤ $: hyperfine 'bash -i'
# Benchmark 1: bash -i
#   Time (mean ± σ):      73.0 ms ±   4.4 ms    [User: 63.7 ms, System: 9.5 ms]
#   Range (min … max):    65.7 ms …  90.9 ms    41 runs


init_config

unset varname


# unset common functions
unset -f main
unset -f cleanup
