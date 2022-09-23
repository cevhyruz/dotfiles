#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Logger for Bash
# Environment:
# DOT_BASH_LOG_LEVEL_ERROR=1
# DOT_BASH_LOG_LEVEL_WARNING=2
# DOT_BASH_LOG_LEVEL_ALL=3

function _has_colors() {
  test -t 1 || return 1
  ncolors=$(tput colors)
  test -n "$ncolors" && test "$ncolors" -ge 8 || return 1
  return 0
}

function _log_general() {
  _about 'Internal function used for logging, uses DOT_BASH_LOG_PREFIX as a prefix'
  _param '1: color of the message'
  _param '2: log level to print before the prefix'
  _param '3: message to log'
  _group 'logger'

  message=$2${DOT_BASH_LOG_PREFIX:-default: }$3
  _has_colors && echo -e "$1${message}${echo_normal:-}" || echo -e "${message}"
}

function _log_debug() {
  _about 'log a debug message by echoing to the screen. needs DOT_BASH_LOG_LEVEL >= BASH_IT_LOG_LEVEL_ALL'
  _param '1: message to log'
  _example '$ _log_debug "Loading plugin git..."'
  _group 'logger'

  [[ "${DOT_BASH_LOG_LEVEL:-0}" -ge $DOT_BASH_LOG_LEVEL_ALL ]] || return 0
  _log_general "${echo_green:-}" "DEBUG: " "$1"
}

function _log_warning() {
  about 'log a message by echoing to the screen. needs DOT_BASH_LOG_LEVEL >= BASH_IT_LOG_LEVEL_WARNING'
  param '1: message to log'
  example '$ _log_warning "git binary not found, disabling git plugin..."'
  group 'logger'

  [[ "${DOT_BASH_LOG_LEVEL:-0}" -ge $DOT_BASH_LOG_LEVEL_WARNING ]] || return 0
  _log_general "${echo_yellow:-}" " WARN: " "$1"
}

function _log_error() {
  about 'log a message by echoing to the screen. needs DOT_BASH_LOG_LEVEL >= BASH_IT_LOG_LEVEL_ERROR'
  param '1: message to log'
  example '$ _log_error "Failed to load git plugin..."'
  group 'logger'

  [[ "${DOT_BASH_LOG_LEVEL:-0}" -ge $DOT_BASH_LOG_LEVEL_ERROR ]] || return 0
  _log_general "${echo_red:-}" "ERROR: " "$1"
}
