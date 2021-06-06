#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

# FZF Plugin for Bash
# Sensible settings for FZF
#
# _FZF_BINDKEYS      : keybindings for fzf.
# _FZF_IGNORED_DIRS  : directory to be ignored.
# _FZF_OPTS          : options for fzf.

_::command_exists "fzf" || return 1

function _set_fzf() {

  local -ar _FZF_BINDKEYS=(
    "ctrl-e:preview-down+preview-down," # preview scroll-down by 2 lines.
    "ctrl-y:preview-up+preview-up,"     # preview scroll-up by 2 lines.
    "ctrl-space:accept")                # additional accept key.

  local -ar _FZF_IGNORED_DIRS=(
    "node_modules/"
    "dist/"
    "bower_components/"
    ".git/"
    "vendors/")

  local -ar _FZF_OPTS=(
    "--ansi"
    "--bind=$(printf "%s" "${_FZF_BINDKEYS[@]}")"
    "--margin=0,0,1" # Top, Right/Left, Bottom
    "--multi"
    "--height=25"
    "--no-bold"
    "--reverse"
    "--inline-info"
    "--header=")

  _set_fzf::_envars
  _set_fzf::_aliases
}

function _set_fzf::_as_ag() {
  for dir in "${_FZF_IGNORED_DIRS[@]}"; do
    ignored_dirs+="*${dir}*,"
  done

  fzf_command=(
    "ag --skip-vcs-ignores"
    "--hidden"
    "--ignore={${ignored_dirs}}"
    "-g ''"
  )
}

function _set_fzf::_as_rg() {
  for dir in "${_FZF_IGNORED_DIRS[@]}"; do
    ignored_dirs+="!${dir}*,"
  done

  fzf_command=(
    "rg --files"
    "--no-ignore"
    "--hidden"
    "--follow"
    "--glob={${ignored_dirs}}"
  )
}

function _set_fzf::_as_find() {
  for dir in "${_FZF_IGNORED_DIRS[@]}"; do
    ignored_dirs+=("! -path './${dir}*'")
  done

  fzf_command=(
    "find . -type f,l,s,p"
    "${ignored_dirs[*]}"
    "| sed 's/^..//'")
}

function _set_fzf::_envars() {
  local fzf_command \
    ignored_dirs

  case "$(basename "$(command -v ag || command -v rg)")" in
  ag) _set_fzf::_as_ag ;;
  rg) _set_fzf::_as_rg ;;
  *) _set_fzf::_as_find ;;
  esac

  export FZF_DEFAULT_COMMAND="${fzf_command[*]}"
  export FZF_DEFAULT_OPTS="${_FZF_OPTS[*]}"

  unset dir \
    fzf_command \
    ignored_dirs
}

function _set_fzf::_aliases() {
  # list aliases.
  alias aliases='alias | fzf'

  # print environment variables.
  alias envars='printenv | fzf'
}

function _set_fzf::_cleanup() {
  unset -f _set_fzf \
    _set_fzf::_as_ag \
    _set_fzf::_as_rg \
    _set_fzf::_as_find \
    _set_fzf::_envars \
    _set_fzf::_cleanup
}

_set_fzf && _set_fzf::_cleanup
