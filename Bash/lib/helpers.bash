#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Core utility functions for managing Dotfiles.
# Entry file to load all library file for bash.
# prevent sourcing this script multiple times.

function _::Util:die() {
  about "Exit gracefully."
  param "[message] (optional)"
  _return "1"

  group "helpers"

  echo >&2 "$1"
  return 1
}

function _::Util:is_dir() {
  _about "Test if given path is a directory."
  _param "[directory path]"
  _return "0 if path is a directory with contents."
  _return "1 if it is empty, non-existent, glob or points to a file."

  _group "helpers"

  local -r DIR_PATH="${1-}"

  [[ -z "$(ls --almost-all "${DIR_PATH}" 2>/dev/null)" ]] && return 1

  if [[ -d "${DIR_PATH}" ]]; then
    return 0
  fi

  return 1
}

function _::Util:is_file() {
  _about "Test if given path is a file."
  _param "[path]"
  _return "0 if [path] is a file"
  _return "1 if it's not-existent, glob or points to a directory."

  _group "helpers"

  local -r FILE_PATH="$1"

  if [[ -f "${FILE_PATH}" ]] ||
    [[ -L "${FILE_PATH}" && -r "${FILE_PATH}" ]]; then
    return 0
  fi

  return 1
}

function _::Util:add_to_path() {
  _about "Add/Prepent [path] into the global environment path."
  _env "PATH"
  _return "0 if the [path] was succesfully added, 1 otherwise."

  _group "helpers"

  local -r DIR_PATH="$1"

  if _::Util:is_dir "${DIR_PATH}"; then
    if ! echo "${PATH//:/\\n}" | grep --quiet "${DIR_PATH}"; then
      export PATH="$1:${PATH}"
    fi
  fi
}

function _::Util:source_file() {
  _about "Source a file."
  _param "[script file]"
  _return "0 if the file was successfully sourced, 1 otherwise."

  _group "helpers"

  source "$1" 2>/dev/null ||
    _::Util:die "can't source '$1'"

  return $?
}

function _::Util:source_files_from() {
  _about "Source all files in a given directory path."
  _param "[directory path]"
  _return "0 if the file was successfully sourced, 1 otherwise."

  _group "helpers"

  local -r DIR_PATH="$1"

  if _::Util:is_dir "${DIR_PATH}"; then

    for FILE in "${DIR_PATH}"/*; do
      if ! _::Util:is_dir; then
        _::Util:source_file "${FILE}"
      fi
    done
    unset FILE
  fi

  return 1
}

function _::source_all_from() {
  _about "Simply all files from [path]."
  _param "[directory path]"
  _return "0 if the file was successfully sourced, 1 otherwise."

  _group "helpers"

  local -r DIR_PATH="$1"

  if _::Util:is_dir "${DIR_PATH}"; then

    for content in "${DIR_PATH}"/*; do
      if _::Util:is_dir "${content}"; then
        _::Util:source_files_from "${content}"
      else
        _::Util:source_file "${content}"
      fi
    done
    unset content
    return $?
  fi

  return 1
}

function _::command_exists() {
  _about "Check if a given command is installed."
  _param "[command]"
  _return "0 if command exists on path, 1 otherwise."

  _group "helpers"

  for cmd in "$@"; do
    if ! command -v "${cmd}" &>/dev/null; then
      return 1
    fi
  done
  return 0
}