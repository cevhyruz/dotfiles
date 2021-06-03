#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

if ! command -v fzf &>/dev/null; then
  return 1
fi

function main() {
  _set_fzf_plugin
  _set_aliases_with_fzf
}

function _set_aliases_with_fzf() {
  alias aliases='alias | fzf'   # list aliases.
  alias envars='printenv | fzf' # print environment variables.
}

function _set_fzf_plugin() {
  local fzf_command
  local -ar FZF_BINDKEYS=(
    "ctrl-e:preview-down+preview-down," # preview scroll-down by 2 lines.
    "ctrl-y:preview-up+preview-up,"     # preview scroll-up by 2 lines.
    "ctrl-space:accept")                # additional accept key.

  local -ar FZF_OPTS=(
    "--ansi"
    "--bind=$(printf "%s" "${FZF_BINDKEYS[@]}")"
    "--margin=0,0,1" # T,RL,B
    "--multi"
    "--height=25"
    "--no-bold"
    "--reverse"
    "--inline-info"
    "--header=")

  local -ar FZF_IGNORE=(
    "node_modules/"
    "bower_components/"
    ".git/"
    "vendors/")

  # [?] exlude directories (default: find)

  # Ag
  if command -v ag &>/dev/null; then
    for dir in "${FZF_IGNORE[@]}"; do
      ignored_dirs+="*${dir}*,"
    done

    fzf_command=(
      "ag --skip-vcs-ignores"
      "--hidden"
      "--ignore={${ignored_dirs}}"
      "-g ''"
    )

  # Rg
  elif command -v rg &>/dev/null; then

    for dir in "${FZF_IGNORE[@]}"; do
      ignored_dirs+="!${dir}*,"
    done

    fzf_command=(
      "rg --files"
      "--no-ignore"
      "--hidden"
      "--follow"
      "--glob={${ignored_dirs}}"
    )

  # find
  else
    for dir in "${FZF_IGNORE[@]}"; do
      ignored_dirs+=("! -path './${dir}*'")
    done

    fzf_command=(
      "find . -type f,l,s,p"
      "${ignored_dirs[*]}"
      "| sed 's/^..//'")
  fi

  unset dir ignored_dirs

  export FZF_DEFAULT_COMMAND="${fzf_command[*]}"
  export FZF_DEFAULT_OPTS="${FZF_OPTS[*]}"
}

main
