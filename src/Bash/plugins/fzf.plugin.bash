#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# FZF Plugin for Bash
# Sensible settings for FZF
#
# Globals:
# DOT_FZF_DEFAULT_CMD : defaults to Ag.

# @FIXME: should not return when mocking tests.
if [[ -z "${TEST_DIRECTORY:-}" ]]; then
  _::command_exists "fzf" || return
fi

# # Auto-completion
# # ---------------
# [[ $- == *i* ]] && source "/home/devs/Projects/forked-repo/fzf/shell/completion.bash" 2> /dev/null
#
# # Key bindings
# # ------------
# source "/home/devs/Projects/forked-repo/fzf/shell/key-bindings.bash"

function main() {
  local -ar __FZF_IGNORED_DIRS=(
    "node_modules/"
    "dist/"
    "bower_components/"
    ".git/"
    "vendors/")

  local -ar __FZF_OPTS=(
    "--ansi"
    "--bind='ctrl-e:preview-down+preview-down'"
    "--bind='ctrl-y:preview-up+preview-up'"
    "--bind='ctrl-space:accept'"
    "--bind='ctrl-s:toggle-sort'"
    "--bind='ctrl-o:clear-selection'"
    "--bind='^:beginning-of-line'"
    "--bind='ctrl-/:toggle-preview'"
    "--bind='?:jump-accept'"
    "--multi"
    "--pointer='❱'"
    "--prompt='➤ '"
    "--height=25"
    "--marker='✸ '"
    "--no-bold"
    "--border=horizontal"
    "--layout=reverse"
    "--preview-window=60%:border-sharp:hidden"
    "--preview='cat {}'"
    "--inline-info"
    "--header='' ")

  local -ar __FZF_THEME=(
    "--color=fg:-1"
    "--color=bg:235"
    "--color=preview-fg:244"
    "--color=preview-bg:234"
    "--color=hl:-1"
    "--color=hl+:0"
    "--color=fg+:0"
    "--color=bg+:245"
    "--color=pointer:221:bold"
    "--color=gutter:235"
    "--color=info:221"
    "--color=border:#333333"
    "--color=prompt:36:bold"
    "--color=marker:36"
    "--color=spinner:196"
    "--color=header:-1")

  __set_fzf "ag"
  __set_fzf_aliases
  cleanup
}

function __set_fzf() {
  local available_command="$1"
  local ignored_dirs
  local fzf_command

  case "${available_command:-ag}" in
    fd) __set_fzf_as_fdfind;;
    ag) __set_fzf_as_ag ;;
    rg) __set_fzf_as_rg ;;
    *) __set_fzf_as_find ;;
  esac

  unset dir

  export FZF_DEFAULT_COMMAND="${fzf_command[*]}"
  export FZF_DEFAULT_OPTS="${__FZF_OPTS[*]}${__FZF_THEME[*]}"
}

function __set_fzf_as_fdfind() {
  fzf_command=(
    "fdfind"
    "--hidden"
    "--no-ignore"
    "--strip-cwd-prefix"
    "--type file")
}

function __set_fzf_as_ag() {
  for dir in "${__FZF_IGNORED_DIRS[@]}"; do
    ignored_dirs+="*${dir}*,"
  done

  fzf_command=(
    "ag"
    "--skip-vcs-ignores"
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
    "rg"
    "--files"
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
    "find"
    "."
    "-type f,l,s,p"
    "${ignored_dirs[*]}"
    "| sed 's/^..//'")
}

function __set_fzf_aliases() {
  # list aliases.
  alias aliases='alias | fzf'
  # print environment variables.
  alias envars='printenv | fzf'
}

function cleanup() {
  unset -f \
    __set_fzf \
    __set_fzf_as_fd \
    __set_fzf_as_ag \
    __set_fzf_as_rg \
    __set_fzf_as_find \
    __set_fzf_command \
    cleanup
}

main
