# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# path.bash - Library for manipulating the $PATH.

# Succeeds if DIR is already an entry in PATH (exact match).
__path_contains() {
  [[ ":${PATH}:" == *":$1:"* ]]
}

# Remove every occurrence of each DIR from PATH.
__path_remove() {
  local entry dir new=""
  local -a parts
  IFS=: read -ra parts <<< "$PATH"
  for entry in "${parts[@]}"; do
    for dir in "$@"; do
      [[ "$entry" == "$dir" ]] && continue 2
    done
    new+="${new:+:}$entry"
  done
  PATH="$new"
}

# Add each DIR to the front of PATH. Arguments keep their given order
# (first argument ends up first). An existing entry is moved to the front.
# Directories that don't exist are skipped.
__path_prepend() {
  local i dir
  for (( i = $#; i >= 1; i-- )); do
    dir="${!i}"
    [[ -d "$dir" ]] || continue
    __path_remove "$dir"
    PATH="$dir${PATH:+:$PATH}"
  done
}
 
# Add each DIR to the end of PATH. Entries already present stay where they are.
# Directories that don't exist are skipped.
__path_append() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] || continue
    __path_contains "$dir" || PATH="${PATH:+$PATH:}$dir"
  done
}
 
# Remove duplicate and empty entries, keeping the first occurrence of each.
__path_dedupe() {
  local entry new=""
  local -a parts
  IFS=: read -ra parts <<< "$PATH"
  for entry in "${parts[@]}"; do
    [[ -n "$entry" ]] || continue
    [[ ":$new:" == *":$entry:"* ]] && continue
    new+="${new:+:}$entry"
  done
  PATH="$new"
}
 
# Dedupe, and also drop entries that aren't existing directories.
__path_clean() {
  local entry new=""
  local -a parts
  IFS=: read -ra parts <<< "$PATH"
  for entry in "${parts[@]}"; do
    [[ -d "$entry" ]] || continue
    [[ ":$new:" == *":$entry:"* ]] && continue
    new+="${new:+:}$entry"
  done
  PATH="$new"
}
 
# Print PATH one entry per line.
__path_list() {
  local IFS=:
  local -a dirs=($PATH)
  printf '%s\n' "${dirs[@]/#$HOME/\~}"
}
