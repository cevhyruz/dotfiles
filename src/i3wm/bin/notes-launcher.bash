#!/usr/bin/env bash
#
# fzf as desktop app launcher

set -e

source "${HOME}/Projects/dotfiles/src/Bash/plugins/fzf.plugin.bash"

cd "${HOME}/Documents/notes" || notify-send "invalid note location";

note="$(find "${HOME}/Documents/notes" -maxdepth 1 -type f -printf '%T@ %f\n' \
  | sort -nr \
  | cut -d' ' -f2- \
  | fzf --prompt='Notes: ')"

nvim "$note"
