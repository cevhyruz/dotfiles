#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Core utility functions for managing Dotfiles.
# Entry file to load all library file for bash.

# @about Add/prepend [path] into the global environment path. {{{1
# @param [path]
# @return 0 if the [path] was successfully added, 1 otherwise.
function _::load() {
  local namespace="${1//[\/\.]/\_}"
  local old_func_def new_func_def
  if ! test -v LOADER_STACK; then
    declare -ag LOADER_STACK=()
  fi
  for entry in "${LOADER_STACK[@]}"; do
    if [[ ${entry} == "${namespace}" ]]; then
      return 1
    fi
  done
  LOADER_STACK+=("${namespace}")
  old_func_def="$(declare -F)"
  source "$1" || return $?
  new_func_def="$(declare -F)"
  # @FIXME: this is pretty slow.
  eval "declare -arg ${namespace}=(
    $(diff --rcs <(echo "${old_func_def}") <(echo "${new_func_def}") |
    grep 'declare' |
    awk '{print $3}'))"
}

# @about Add/prepend [path] into the global environment path. {{{1
# @param [path]
# @return 0 if the [path] was successfully added, 1 otherwise.
function _::unload() {
  local -r stack_name="$1"
  local -r stack="${stack_name}[@]"
  for func in "${!stack}"; do
    echo "${func} -function"
    unset -f "${func}"
  done
  unset -v func "LOADER_STACK[${#LOADER_STACK[@]}-1]"
}

# @about Add/prepend [path] into the global environment path. {{{1
# @param [path]
# @return 0 if the [path] was successfully added, 1 otherwise.
function _::add_to_path() {
  if [[ -d ${1:-} && ! $PATH =~ (^|:)"${1}"($|:) ]]; then
    if [[ ${2:-before} == "after" ]]; then
      export PATH="${PATH}:$1"
    else
      export PATH="$1:${PATH}"
    fi
    return
  fi
  return 1
}

# @about Source a file.
# @param  [path]
# @param2 [name reference] for unsourcing the script file.
# @return 0 if the file was succesfully sourced, 1 otherwise.
function _::source_file() {
  local -r file="$1"
  _::load "$file" "$2"
  return $?
}

# @about Source a bash script file.
# @param  [path]
# @return 0 if the file was succesfully sourced, 1 otherwise.
function _::source_files_from() {
  local -r DIR_PATH="$1"
  if test -d "${DIR_PATH}"; then
    for file in "${DIR_PATH}"/*; do
      if ! test -d "${file}"; then
        _::load "${file}" "${file}"
      fi
    done
    unset FILE
  fi
  return 1
}

# _::command_exists() Check if a given command is installed {{{1
# Args [command]
# Returns:
#  0 if command exists on path, 1 otherwise
function _::command_exists() {
  _about "Check if a given command is installed."
  _param "[command]"
  _return "0 if command exists on path, 1 otherwise."

  _group "helpers"

  local cmd="$1"
  if command -v "${cmd}" &>/dev/null; then
    return 0
  fi
  return 1
}

# _::is_func() Check if a given command is a declared function {{{1
# Args [command]
# Returns:
#  0 if command is a function, 1 otherwise
function _::is_func() {
  if declare -F "${1:-}" &>/dev/null; then
    return 0
  fi
  return 1
}
