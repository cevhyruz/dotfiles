#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# FZF Plugin for Bash
# Sensible settings for FZF
#
# Globals:
# DOT_FZF_DEFAULT_CMD : defaults to Ag.

_::command_exists "fzf" || return

function __bootstrap_fzf() {
  local -ar __FZF_BINDKEYS=(
    "ctrl-e:preview-down+preview-down,"
    "ctrl-y:preview-up+preview-up,"
    "ctrl-space:accept,"
    "ctrl-s:toggle-sort,"
    "ctrl-o:clear-selection,"
    "^:beginning-of-line,"
    "$:end-of-line,"
    "ctrl-/:toggle-preview,"
    "alt-h:change-preview-window(60%|70%|80%),"
    "?:jump-accept")

  local -ar __FZF_IGNORED_DIRS=(
    "node_modules/"
    "dist/"
    "bower_components/"
    ".git/"
    "vendors/")

  local -ar __FZF_OPTS=(
    "--ansi"
    "--bind='$(printf "%s" "${__FZF_BINDKEYS[@]}")'"
    "--margin=0,0,1" # T, RL, B
    "--multi"
    "--tac"
    "--pointer='❱'"
    "--height=25"
    "--marker='✸ '"
    "--no-bold"
    "--border=horizontal"
    "--layout=reverse"
    "--preview-window=border-sharp"
    "--preview='cat {}'"
    "--inline-info"
    "--header='' ")

  # fade-in-black theme
  # yin-yang
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
    "--color=border:237"
    "--color=prompt:36"
    "--color=marker:36"
    "--color=spinner:196"
    "--color=header:-1")

  __set_fzf
  __set_fzf_aliases
  __cleanup
}

function __available_command() {
  basename "$(
    command -v ag \
      || command -v rg \
      || command -v fdfind
  )"
}

function __set_fzf() {
  local ignored_dirs
  local fzf_command

  case "${DOT_FZF_DEFAULT_CMD:-$(__available_command)}" in
    fd) __set_fzf_as_fdfind ;;
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
    __set_fzf_as_fd \
    __set_fzf_as_ag \
    __set_fzf_as_rg \
    __set_fzf_as_find \
    __set_fzf_command \
    __available_command \
    __cleanup
}

__bootstrap_fzf
