#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

# Add this to the API.

function timer() {
  for i in "${_dotfiles_runtime[@]}"; do
    TIMEFORMAT="${i//${HOME}/\~}: %R"
    time source "$i"
    unset TIMEFORMAT
  done;
  unset i
  stty cooked
}


function fulbar() {
  echo "\e[38;5;216m This is just a fulbar test \e[0m"
}

function safe_timer() {
  # Save current terminal settings
  local old_stty
  old_stty=$(stty -g)

  local total_start total_end total_elapsed
  total_start=$(date +%s.%N)  # total timer start

  local i start end elapsed
  for i in "${_dotfiles_runtime[@]}"; do
    # echo "Sourcing: ${i//$HOME/~}"

    start=$(date +%s.%N)  # script timer start

    # Source script safely
    (
      # Ensure terminal is restored on error
      trap 'stty "$old_stty"; exit 1' ERR
      source "$i"
    )

    end=$(date +%s.%N)  # script timer end
    elapsed=$(echo "$end - $start" | bc)
    printf "  %s: %.3f seconds\n" "${i//$HOME/~}" "$elapsed"

    # Restore terminal settings after each script
    # stty "$old_stty"
  done

  total_end=$(date +%s.%N)
  total_elapsed=$(echo "$total_end - $total_start" | bc)
  printf "\nTotal time: %.3f seconds\n" "$total_elapsed"
}

# function safe_timer() {
#   local old_stty
#
#   local total_elapsed=0
#   local i start end elapsed
#
#   for i in "${_dotfiles_runtime[@]}"; do
#     # echo "Sourcing: ${i//$HOME/~}"
#
#     start=$(date +%s.%N)
#
#     # save current state
#     old_stty=$(stty -g)
#
#     # Source interactively
#     source "$i"
#
#
#     end=$(date +%s.%N)
#     elapsed=$(echo "$end - $start" | bc)
#
#     printf "  %s: %.3f seconds\n" "${i//$HOME/~}" "$elapsed"
#
#     # Accumulate total
#     total_elapsed=$(echo "$total_elapsed + $elapsed" | bc)
#
#   done
# }
