# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Core utility functions for managing Dotfiles.
# Entry file to load all library file for bash.

# prevent sourcing this script multiple times.
#[[ -n ${UTIL_LOADED-} ]] && return || UTIL_LOADED=true

#  _::die() Exit gracefully. {{{1
# Args [message] (optional)
# Returns: 1
function _::die() {
  echo >&2 "$1"
  return 1
}

# _::is_dir() Test if given path is a directory. {{{1
# Args [directory path]
# Returns:
#   0 if path is dir with contents,
#   1 if it's empty, non-existent, glob or points to a file.
function _::is_dir() {
  local -r DIR_PATH="${1-}"

  [[ -z "$(ls --almost-all "${DIR_PATH}" 2>/dev/null)" ]] && return 1

  if [[ -d "${DIR_PATH}" ]]; then
    return 0
  fi

  return 1
}

# _::is_file() Test if given path is a file. {{{1
# Args [directory path]
# Returns:
#   0 if path is file,
#   1 if it's non-existent, glob or points to a directory.
function _::is_file() {
  local -r FILE_PATH="$1"

  if [[ -f "${FILE_PATH}" ]] ||
    [[ -L "${FILE_PATH}" && -r "${FILE_PATH}" ]]; then
    return 0
  fi

  return 1
}

# _::add_to_path() Add/Prepend [path] into environment path. {{{1
# Arguments: [path]
# Globals:
#   PATH
# Returns:
#   0 if [path] was added, 1 if path doesnt exist.
function _::add_to_path() {
  local -r DIR_PATH="$1"

  if _::is_dir "${DIR_PATH}"; then
    if ! echo "${PATH//:/\\n}" | grep --quiet "${DIR_PATH}"; then
      export PATH="$1:${PATH}"
    fi
  fi
}

# _::source_file() Source a file. {{{1
# Args [script file]
# Returns:
#   0 if the file was successfully sourced, 1 otherwise.
function _::source_file() {
  source "$1" 2>/dev/null ||
    _::die "can't source '$1'"

  return $?
}

# _::source_files_from() Source all files in a given directory path {{{1
# Args [directory path]
# Returns:
#   0 if the file was successfully sourced, 1 otherwise.
function _::source_files_from() {
  local -r DIR_PATH="$1"

  if _::is_dir "${DIR_PATH}"; then

    for FILE in "${DIR_PATH}"/*; do
      if ! _::is_dir; then
        _::source_file "${FILE}"
      fi
    done
    unset FILE
  fi

  return 1
}

# _::source_all_from() Source files in [path] {{{1
# including first level sub-directories.
# Args [directory path]
# Returns:
#   0 if the file was successfully sourced, 1 otherwise.
function _::source_all_from() {
  local -r DIR_PATH="$1"

  if _::is_dir "${DIR_PATH}"; then

    for content in "${DIR_PATH}"/*; do
      if _::is_dir "${content}"; then
        _::source_files_from "${content}"
      else
        _::source_file "${content}"
      fi
    done
    unset content
    return $?
  fi

  return 1
}
