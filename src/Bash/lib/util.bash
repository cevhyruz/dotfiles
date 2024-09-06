#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Core utility functions for managing Dotfiles.
# Entry file to load all library file for bash.


# make prompt var that changes value depending on last command return status.
# @param1: variable to store colors
# @param2: value of the variable when last command is true
# @param3: value of the variable when last command is false
#
function _make_prompt_var() {
  if [[ "${ret:-${EXIT_CODE-}}" -eq 0 ]]; then
    eval "declare -g $1=\"$2\""
  else
    eval "declare -g $1=\"$3\""
  fi
}

# @about Add/prepend [path] into the global environment path. {{{1
# @param [path]
# @return 0 if the [path] was successfully added, 1 otherwise.
#
function _::add_to_path() {
  if [[ -d ${1:-} && ! $PATH =~ (^|:)"${1}"($|:) ]]; then
    if [[ ${2:-before} == "after" ]]; then
      export PATH="${PATH}:$1"
    else
      export PATH="$1:${PATH}"
    fi
    return
  fi
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

  local cmd="${1:-}"
  if command -v "${cmd}" &>/dev/null; then
    return 0
  fi
  return 1
}

# _::is_installed check if given program is installed {{{1
# by checking if the reference variable is declared.
# if yes, then declare another variable for reference to enable/disable 
# the plugin given.
function _::is_installed() {
  local program="$1"
  local plugin_name="$2"
  plugin_name="__plug_${plugin_name}_installed"
  # if the reference variable is not declared then
  # the program required is not installed.
  if declare -p "$varname" &>/dev/null; then
    eval "declare -g __bash_plug_${plugin_name}_loaded=1"
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
