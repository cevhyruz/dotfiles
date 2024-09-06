#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=bash fdm=marker ts=2 sw=2 et

# FZF Plugin for Bash
# Sensible settings for FZF
#
# Globals:
# DOT_FZF_DEFAULT_CMD : defaults to Ag.

# @FIXME: should not return when mocking tests.
# if [[ -z "${TEST_DIRECTORY:-}" ]]; then
#   _::is_installed "fzf" "fzf" || return
# fi

function __preview() {
  local filetype="$1"

  if [[ "${filetype}" == *.png||*.jpeg ]]; then
    kitty icat --clear --transfer-mode=memory --stdin=no --place="${FZF_PREVIEW_COLUMNS:-}x${FZF_PREVIEW_LINES}@0x0" $filetype; seq 100;
  else
    batcat --style=numbers --color=always --line-range :500 "$1"
  fi

}

function main() {
  export -f __preview


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
    #"--bind='ctrl-o:clear-selection'"
    "--bind='ctrl-s:toggle-sort'"
    "--bind='^:beginning-of-line'"
    "--bind='ctrl-/:toggle-preview'"
    "--bind='?:jump-accept'"
    "--multi"
    "--pointer=' '"
    #"--prompt=' ~/Projects/dotfiles: '"
    "--height=25"
    "--marker='✸ '"
    "--separator=''"
    "--no-bold"
    #"--border-label='│ Find files │'"
    #"--border=horizontal"
    "--layout=reverse"
    "--preview-window=60%:hidden:border-sharp"
    # "--preview='__preview {}'"
    "--preview='batcat --style=numbers --color=always --line-range :500 {}'"
#    "--info='hidden'"
    "--scrollbar='▉'"
    "--header='========================================================================' ")

  local bg="#1E1E1E"
  local fg="-1"

  # little darker than bg and fg
  local prev_bg="#1E1E1E"
  local prev_fg="244"

  local -ar __FZF_THEME=(

    # -1 = terminal default fg/bg

    "--color=fg:$fg"            # Text
    "--color=bg:$bg"           # Background
    "--color=preview-fg:$prev_fg"   # Preview window text
    "--color=preview-bg:$prev_bg"   # Preview window background
    "--color=hl:1"            # Highlighted substrings
    "--color=fg+:249"            # Text (Current line)
    "--color=bg+:#333333"          # Background (Current line)
    "--color=gutter:$bg"       # Gutter on the left (defaults to bg+)
    "--color=hl+:249"            # Highlighted substrings (current line)
    "--color=query:$fg"          # Query string
    "--color=disabled:0"       # Query string when search is disabled
    "--color=info:221"         # Info line (match counters)
    "--color=separator:221"    # Horizontal separator on info line (match counters)
    "--color=border:31"       # Border around the window (--border and --preview)
    "--color=label:$fg"         # Border label (--border-label and --preview-label)
    "--color=prompt:36:bold"   # Prompt
    "--color=pointer:221:bold" # Pointer to the current line
    "--color=marker:35"        # Multi-select marker
    "--color=spinner:196"      # Streaming input indicator
    "--color=header:$fg")       # Header

  __set_fzf "ag"
  __set_fzf_aliases
  cleanup
}

function __set_fzf() {
  local preffered_command="$1"
  local ignored_dirs
  local fzf_command

  case "${available_command:-find}" in
    fd) __set_fzf_as_fdfind;;
    ag) __set_fzf_as_ag ;;
    rg) __set_fzf_as_rg ;;
    find) __set_fzf_as_find ;;
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
