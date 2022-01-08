#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

# FZF Plugin for Bash
# Sensible settings for FZF
#
# _FZF_BINDKEYS      : keybindings for fzf.
# _FZF_IGNORED_DIRS  : directory to be ignored.
# _FZF_OPTS          : options for fzf.

_::command_exists "fzf" || return

function __bootstrap_fzf() {
  local -ar __FZF_BINDKEYS=(
    "ctrl-e:preview-down+preview-down," # preview scroll down by 2 lines.
    "ctrl-y:preview-up+preview-up,"     # preview scroll up by 2 lines.
    "ctrl-space:accept")                # additional accept key.

  declare -ar __FZF_IGNORED_DIRS=(
    "node_modules/"
    "dist/"
    "bower_components/"
    ".git/"
    "vendors/")

  local -ar __FZF_OPTS=(
    "--ansi"
    "--bind=$(printf "%s" "${__FZF_BINDKEYS[@]}")"
    "--margin=0,0,1" # Top, Right/Left, Bottom
    "--multi"
    "--height=25"
    "--no-bold"
    "--color=bw"
    "--reverse"
    "--inline-info"
    "--header=")

  __set_fzf
  __set_fzf_aliases
  __cleanup
}

function __set_fzf() {
  local available_cmd
  local ignored_dirs
  local fzf_command

  available_cmd="$(basename "$(command -v ag || command -v rg)")"

  case "${available_cmd}" in
  ag) __set_fzf_as_ag ;;
  rg) __set_fzf_as_rg ;;
  *) __set_fzf_as_find ;;
  esac

  unset dir

  export FZF_DEFAULT_COMMAND="${fzf_command[*]}"
  export FZF_DEFAULT_OPTS="${__FZF_OPTS[*]}"
}

function __set_fzf_as_ag() {
  for dir in "${__FZF_IGNORED_DIRS[@]}"; do
    ignored_dirs+="*${dir}*,"
  done

  fzf_command=(
    "ag --skip-vcs-ignores"
    "--hidden"
    "--ignore={${ignored_dirs}}"
    "-g ''"
  )
}

function __set_fzf_as_rg() {
  for dir in "${__FZF_IGNORED_DIRS[@]}"; do
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

function __set_fzf_as_find() {
  for dir in "${__FZF_IGNORED_DIRS[@]}"; do
    ignored_dirs+=("! -path './${dir}*'")
  done

  fzf_command=(
    "find . -type f,l,s,p"
    "${ignored_dirs[*]}"
    "| sed 's/^..//'")
}

function __set_fzf_aliases() {
  # list aliases.
  alias aliases='alias | fzf'
  # print environment variables.
  alias envars='printenv | fzf'
}

function __cleanup() {
  unset -f \
    __set_fzf \
    __set_fzf_as_ag \
    __set_fzf_as_rg \
    __set_fzf_as_find \
    __set_fzf_command \
    __cleanup
}

__bootstrap_fzf
